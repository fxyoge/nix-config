set -eou pipefail

mkdir -p "$HOME/Documents/Finance"
hledger-flow import "$HOME/Documents/Finance"
