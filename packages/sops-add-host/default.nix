{ pkgs, ... }: let
    pname = "sops-add-host";
in pkgs.symlinkJoin {
    name = pname;
    paths = with pkgs; [
        (writeShellApplication {
            name = pname;
            runtimeInputs = [ ssh-to-age yq-go ];
            text = builtins.readFile ./sops-add-host.sh;
        })
    ];
}
