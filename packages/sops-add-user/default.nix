{ pkgs, ... }: pkgs.writeShellScriptBin "sops-add-user" ''
  set -eou pipefail

  current_user=$(whoami)
  hostname=$(hostname)
  sops_yaml_path="/etc/nixos/nix-private/.sops.yaml"
  ssh_key_path="$HOME/.ssh/id_ed25519"

  if [ ! -f "$sops_yaml_path" ]; then
      echo "$sops_yaml_path does not exist"
      exit 1
  fi

  if [ ! -f "$ssh_key_path" ]; then
      echo "generating user ssh key"
      ssh-keygen -t ed25519 -C "$current_user@$hostname" -f "$ssh_key_path" -N ""
  else
      echo "ssh key already exists, skipping generation"
  fi

  age_public_key=$(${pkgs.ssh-to-age}/bin/ssh-to-age < "$ssh_key_path.pub")

  echo "generating age key from ssh key"
  mkdir -p "$HOME/.config/sops/age"
  ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$ssh_key_path" > "$HOME/.config/sops/age/keys.txt"

  echo "adding user key to .sops.yaml"
  anchor="$(echo $current_user)_$(echo $hostname)"
  ${pkgs.yq-go}/bin/yq -i "
      .keys += \"$age_public_key\" |
      .keys[-1] anchor = \"$anchor\" |
      .creation_rules[0].key_groups[0].age += \"\" |
      .creation_rules[0].key_groups[0].age[-1] alias = \"$anchor\"
  " "$sops_yaml_path"
''
