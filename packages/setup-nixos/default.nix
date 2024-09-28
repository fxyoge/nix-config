{ pkgs, ... }: let
    pname = "setup-nixos";
in pkgs.symlinkJoin {
    name = pname;
    paths = with pkgs; [
        (writeShellScriptBin pname ./setup-nixos.sh)
        cacert
        git
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = "wrapProgram $out/bin/${pname} --prefix PATH : $out/bin";
}
