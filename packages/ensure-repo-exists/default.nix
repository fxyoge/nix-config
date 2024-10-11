{ pkgs, ... }: let
    pname = "ensure-repo-exists";
in pkgs.symlinkJoin {
    name = pname;
    paths = with pkgs; [
        (writeShellApplication {
            name = pname;
            runtimeInputs = [ git ];
            text = builtins.readFile ./ensure-repo-exists.sh;
        })
    ];
}
