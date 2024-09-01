{ pkgs, ... }: let
  # TODO: This script is remarkably inefficient and the journal should be restructured
  #       to take advantage of `include`s.
  hledger-wrapper = (pkgs.writeShellScriptBin "hledger-wrapper" ''
    set -e

    journal_path="$HOME/Repos/fxyoge/finance"

    if [ ! -d "$journal_path" ]; then
      echo "journal does not exist"
      exit 1
    fi

    agg_journal="/tmp/$(uuidgen)"
    touch "$agg_journal"
    trap "rm '$agg_journal'" EXIT

    find "$journal_path" -type f -name "*.journal" | sort | while read -r file; do
      cat "$file" >> "$agg_journal"
      echo >> "$agg_journal"
    done

    LEDGER_FILE="$agg_journal" ${pkgs.hledger}/bin/hledger "$@"
  '');
  finreport-accounts = (pkgs.writeShellScriptBin "finreport-accounts" ''
    ${hledger-wrapper}/bin/hledger-wrapper -I accounts --types
  '');
in {
  home.packages = [
    finreport-accounts
  ];
}
