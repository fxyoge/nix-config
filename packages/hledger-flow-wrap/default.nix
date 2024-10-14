{ pkgs, ... }: let
    pname = "hledger-flow-wrap";
in pkgs.writeShellApplication {
    name = pname;
    runtimeInputs = with pkgs; [
        hledger
        #haskellPackages.hledger-flow
        (callPackage ../hledger-flow-xlsx2csv {})
    ];
    text = builtins.readFile ./script.sh;
}
