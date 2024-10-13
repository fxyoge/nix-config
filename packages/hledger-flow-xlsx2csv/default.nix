{ pkgs, ... }: let
    pname = "hledger-flow-xlsx2csv";
in pkgs.writers.writePython3Bin pname {
    libraries = with pkgs.python3.pkgs; [ pandas openpyxl ];
    flakeIgnore = [ "E128" "E501" "W293" ];
} ./script.py
