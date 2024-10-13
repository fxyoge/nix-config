{ config, inputs, lib, pkgs, ... }: let
  finreport-dl = (pkgs.writers.writePython3Bin "finreport-dl" {
    libraries = with pkgs.python3.pkgs; [ platformdirs pykeepass ];
    flakeIgnore = [ "E128" "E501" "W293" ];
  } ./finreport-dl.py);
  runners = lib.attrsets.attrValues (
    lib.filterAttrs (name: _: builtins.match "finreport-dl-.+-run" name != null) inputs.finreport-dl.packages.${pkgs.system}
  );
in {
  imports = [
    inputs.private.modules.home.finreport-dl
  ];

  home.packages = [
    finreport-dl
  ] ++ runners;
  xdg.configFile."finreport-dl/config.json".text = builtins.toJSON ({
    keepass_db_path = config.fxy.paths.keepassVault;
    default_targets = config.fxy.finance.defaultTargets;
    targets = config.fxy.finance.targets;
  });
}
