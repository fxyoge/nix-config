set -eou pipefail

hostname=$(hostname)
sops_yaml_path="/etc/nixos/nix-private/.sops.yaml"

if [ ! -f "$sops_yaml_path" ]; then
  echo "$sops_yaml_path does not exist"
  exit 1
fi

echo "generating root ssh key"
sudo ssh-keygen -t ed25519 -C "root@$hostname" -f "/root/.ssh/id_ed25519" -N ""

age_public_key=$(sudo bash -c "ssh-to-age < /root/.ssh/id_ed25519.pub")

echo "generating age key from ssh key"
sudo mkdir -p /root/.config/sops/age
sudo bash -c "ssh-to-age -private-key -i /root/.ssh/id_ed25519 > /root/.config/sops/age/keys.txt"

echo "adding host key to .sops.yaml"
yq -i "
  .keys += \"$age_public_key\" |
  .keys[-1] anchor = \"$hostname\" |
  .creation_rules[0].key_groups[0].age += \"\" |
  .creation_rules[0].key_groups[0].age[-1] alias = \"$hostname\"
" "$sops_yaml_path"
