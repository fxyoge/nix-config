{pkgs, ...}: let
  pname = "setup-nixos";
in
  pkgs.symlinkJoin {
    name = pname;
    paths = with pkgs; [
      (writeShellApplication {
        name = pname;
        runtimeInputs = [git (callPackage ../sops-add-user {})];
        text = builtins.readFile ./setup-nixos.sh;
      })
    ];
  }
