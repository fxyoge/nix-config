{
  config,
  pkgs,
  ...
}: let
  feedparser = let
    pname = "feedparser";
    version = "6.0.11";
    sha256 = "sha256-ydBAe2TG8qBl0OuyksKzXAEFDMDcM3V0Yaqr3ExBhNU=";
  in
    pkgs.python3Packages.buildPythonPackage {
      inherit pname version;
      src = pkgs.fetchPypi {inherit pname version sha256;};
      doCheck = false;
    };
  sgmllib3k = let
    pname = "sgmllib3k";
    version = "1.0.0";
    sha256 = "sha256-eGj7HIv6dkwaxWPTzzacOB0TJdNhJJM6cm8p/NqoEuk=";
  in
    pkgs.python3Packages.buildPythonPackage {
      inherit pname version;
      src = pkgs.fetchPypi {inherit pname version sha256;};
      doCheck = false;
    };
  fxy-greader =
    pkgs.writers.writePython3Bin "fxy-greader" {
      libraries = with pkgs.python3.pkgs; [feedparser flask platformdirs requests sgmllib3k waitress];
      flakeIgnore = ["E128" "E501" "W293"];
    }
    ./script.py;
in {
  home-manager.users.fxyoge = {
    home.packages = [
      fxy-greader
    ];

    systemd.user.services."fxy-greader" = {
      Unit = {
        Description = "Local GReader Service";
        After = ["network.target"];
        X-Restart-Triggers = [
          fxy-greader
        ];
      };

      Install.WantedBy = ["multi-user.target"];

      Service = {
        ExecStart = "${fxy-greader}/bin/fxy-greader -d \"/home/${config.fxy.user}/Documents/Feeds\"";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
