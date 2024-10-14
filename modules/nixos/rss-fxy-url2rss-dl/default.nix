{ config, pkgs, ... }: let
  feedparser =
    let
      pname = "feedparser";
      version = "6.0.11";
      sha256 = "sha256-ydBAe2TG8qBl0OuyksKzXAEFDMDcM3V0Yaqr3ExBhNU=";
    in
    pkgs.python3Packages.buildPythonPackage {
      inherit pname version;
      src = pkgs.fetchPypi { inherit pname version sha256; };
      doCheck = false;
    };
  sgmllib3k =
    let
      pname = "sgmllib3k";
      version = "1.0.0";
      sha256 = "sha256-eGj7HIv6dkwaxWPTzzacOB0TJdNhJJM6cm8p/NqoEuk=";
    in
    pkgs.python3Packages.buildPythonPackage {
      inherit pname version;
      src = pkgs.fetchPypi { inherit pname version sha256; };
      doCheck = false;
    };
  fxy-url2rss-dl = (pkgs.writers.writePython3Bin "fxy-url2rss-dl" {
    libraries = with pkgs.python3.pkgs; [ feedparser platformdirs requests sgmllib3k ];
    flakeIgnore = [ "E128" "E501" "W293" ];
  } ./script.py);
in {
  sops.secrets.fxy-url2rss-dl-config = config.fxy.secrets.url2rssConfig // {
    path = "/home/${config.fxy.user}/.config/fxy-url2rss-dl/config.json";
    owner = config.fxy.user;
    group = "users";
  };

  home-manager.users.fxyoge = {
    home.packages = [
      fxy-url2rss-dl
    ];

    systemd.user.timers."fxy-url2rss-dl" = {
      Unit = { Description = "Run fxy-url2rss-dl every 30 minutes"; };
      Timer = {
        OnUnitActiveSec = "30m";
        OnStartupSec = "5m";
        Unit = "fxy-url2rss-dl.service";
      };
      Install = { WantedBy = [ "timers.target" ]; };
    };

    systemd.user.services."fxy-url2rss-dl" = {
      Unit = { Description = "Download basic RSS feeds"; };
      Service = {
        Type = "simple";
        ExecStart = "${fxy-url2rss-dl}/bin/fxy-url2rss-dl --output \"${config.fxy.paths.feedsDir}\"";
      };
    };
  };
}
