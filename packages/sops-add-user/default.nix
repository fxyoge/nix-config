{ pkgs, ... }: let
    pname = "sops-add-user";
in pkgs.symlinkJoin {
    name = pname;
    paths = with pkgs; [
        (writeShellApplication {
            name = pname;
            runtimeInputs = [ ssh-to-age yq-go ];
            text = builtins.readFile ./sops-add-user.sh;
        })
    ];
}
