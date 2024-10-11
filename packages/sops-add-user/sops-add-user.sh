set -eou pipefail

echo "$@"

options=$(getopt -o h,f: -l help,file: -n "$0" -- "$@") || exit
eval set -- "$options"

print_usage() {
  echo "USAGE: $(basename "$0") [OPTION]..."
  echo "Adds the current user to a SOPS configuration."
  echo ""
  echo "Options:"
  echo "  -f, --file      The path to the .sops.yaml file. Default is ./.sops.yaml"
  echo "  -h, --help      Display this help message."
}

sops_yaml_path="./.sops.yaml"

while [[ $1 != -- ]]; do
  case $1 in
    -h|--help) print_usage; exit 0 ;;
    -f|--file) sops_yaml_path="$2"; shift 2 ;;
    *) echo "Invalid option: $1" >&2; print_usage >&2; exit 1 ;;
  esac
done
shift

if [ ! -f "$sops_yaml_path" ]; then
  echo "$sops_yaml_path does not exist"
  exit 1
fi

current_user=$(whoami)
hostname=$(hostname)
ssh_key_path="$HOME/.ssh/id_ed25519"

if [ ! -f "$ssh_key_path" ]; then
  echo "Generating user SSH key"
  ssh-keygen -t ed25519 -C "$current_user@$hostname" -f "$ssh_key_path" -N ""
else
  echo "SSH key already exists, skipping generation"
fi

age_public_key=$(ssh-to-age < "$ssh_key_path.pub")

echo "Ensuring age key from SSH key"
mkdir -p "$HOME/.config/sops/age"
if [ ! -f "$HOME/.config/sops/age/keys.txt" ]; then
  ssh-to-age -private-key -i "$ssh_key_path" > "$HOME/.config/sops/age/keys.txt"
fi

echo "Ensuring user key in .sops.yaml"
anchor="${current_user}_${hostname}"

if ! yq e ".keys[] | select(. == \"$age_public_key\")" "$sops_yaml_path" > /dev/null; then
  yq -i "
    .keys += \"$age_public_key\" |
    .keys[-1] anchor = \"$anchor\" |
    .creation_rules[0].key_groups[0].age += \"\" |
    .creation_rules[0].key_groups[0].age[-1] alias = \"$anchor\"
  " "$sops_yaml_path"
  echo "User added to $sops_yaml_path"
else
  echo "User already exists in $sops_yaml_path, no changes made"
fi
