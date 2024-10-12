{ config, inputs, pkgs, ... }: let
  finreport-dl = (pkgs.writers.writePython3Bin "finreport-dl" {
    libraries = with pkgs.python3.pkgs; [ platformdirs pykeepass ];
    flakeIgnore = [ "E128" "E501" "W293" ];
  } ./finreport-dl.py);
in {
  imports = [
    inputs.private.modules.home.finreport-dl
  ];

  home.packages = [
    finreport-dl
  ];
  xdg.configFile."finreport-dl/config.json".text = builtins.toJSON ({
    keepass_db_path = config.fxy.paths.keepassVault;
    default_targets = config.fxy.finance.defaultTargets;
    targets = config.fxy.finance.targets;
  });
}
