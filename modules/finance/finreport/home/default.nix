{ pkgs, ... }: let
  finreport-accounts = (pkgs.writeShellScriptBin "finreport-accounts" ''
    journal_path="$HOME/Repos/fxyoge/finance/0_all"
    ${pkgs.hledger}/bin/hledger -f "$journal_path" -I accounts --types
  '');
  finreport-bs = (pkgs.writeShellScriptBin "finreport-bs" ''
    set -e
    options=$(getopt -o p: -l period: -n "$0" -- "$@") || exit
    eval set -- "$options"
    arg_period="quarterly from 12 quarters ago"
    journal_path="$HOME/Repos/fxyoge/finance/0_all"
    while [[ $1 != -- ]]; do
      case $1 in
        -p|--period) arg_period="$2"; shift 2;;
        *) echo "bad option: $1" >&2; shift 1;;
      esac
    done
    shift
    ${pkgs.hledger}/bin/hledger balancesheet -f "$journal_path" -V --infer-value --period "$arg_period"
  '');
  finreport-inventory = (pkgs.writers.writePython3Bin "finreport-inventory" {
    flakeIgnore = [ "E128" "E501" "W293" ];
  } ./finreport-inventory.py);
  finreport-is = (pkgs.writeShellScriptBin "finreport-is" ''
    set -e
    options=$(getopt -o p: -l period: -n "$0" -- "$@") || exit
    eval set -- "$options"
    arg_period="quarterly from 12 quarters ago"
    journal_path="$HOME/Repos/fxyoge/finance/0_all"
    while [[ $1 != -- ]]; do
      case $1 in
        -p|--period) arg_period="$2"; shift 2;;
        *) echo "bad option: $1" >&2; shift 1;;
      esac
    done
    shift
    ${pkgs.hledger}/bin/hledger incomestatement -f "$journal_path" -V --infer-value --period "$arg_period"
  '');
in {
  home.packages = [
    finreport-accounts
    finreport-bs
    finreport-inventory
    finreport-is
    pkgs.hledger
  ];
}
