{ pkgs-personal, ... }: let
    pname = "hledger-flow-wrap";
in pkgs-personal.writeShellApplication {
    name = pname;
    runtimeInputs = with pkgs-personal; [
        hledger
        haskellPackages.hledger-flow
        (callPackage ../hledger-flow-xlsx2csv {})
    ];
    text = builtins.readFile ./script.sh;
}
