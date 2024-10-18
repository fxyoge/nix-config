{
  perSystem,
  pkgs,
  ...
}: let
  pname = "finreport-dl";
  main =
    pkgs.writers.writePython3Bin pname {
      libraries = with pkgs.python3.pkgs; [platformdirs pykeepass];
      flakeIgnore = ["E128" "E501" "W293"];
    }
    ./script.py;
  runners = pkgs.lib.attrsets.attrValues (
    pkgs.lib.filterAttrs (name: _: builtins.match "finreport-dl-.+-run" name != null) perSystem.finreport-dl
  );
in
  pkgs.writeShellApplication {
    name = pname;
    runtimeInputs = runners;
    text = ''
      ${pkgs.lib.getExe main} "$@"
    '';
  }
