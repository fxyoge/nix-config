set -eou pipefail

if [ "$(id -u)" -eq 0 ]; then
  echo "Do not run this script as root, please!"
  exit 1
fi

my_user=$(id -un)
my_group=$(id -gn)
hostname=$(hostname)

is_nixos() {
  if [ -f /etc/os-release ]; then
    grep -q '^NAME="NixOS"$' /etc/os-release
  else
    false
  fi
}

for repo in nix-config nix-private; do
  if [ ! -d /etc/nixos/$repo ]; then
    echo "/etc/nixos/$repo not detected; cloning!"
    git clone git@github.com:fxyoge/$repo.git
    sudo mv $repo /etc/nixos/$repo
  else
    echo "/etc/nixos/$repo already exists; skipping"
  fi
done

for config_file in configuration.nix hardware-configuration.nix; do
  if [ -f /etc/nixos/$config_file ]; then
    echo "/etc/nixos/$config_file detected; moving to host configuration"
    mkdir -p "/etc/nixos/nix-config/hosts/$hostname"
    sudo chown "$my_user:$my_group" /etc/nixos/$config_file
    sudo mv /etc/nixos/$config_file "/etc/nixos/nix-config/hosts/$hostname/$config_file"
  else
    echo "/etc/nixos/$config_file not detected; skipping"
  fi
done

add_config_to_flake() {
  local config_type=$1
  local config_name=$2
  local config_content=$3
  local end_marker=$4

  if ! grep -qE "\"?$config_name\"? = (nixpkgs\\.lib\\.nixosSystem|home-manager\\.lib\\.homeManagerConfiguration)\\s+{" /etc/nixos/nix-config/flake.nix; then
    sed -i "/$end_marker/i\\${config_content//$'\n'/\\n}" /etc/nixos/nix-config/flake.nix
    echo "Added $config_type configuration for $config_name to flake.nix"
  else
    echo "$config_type configuration for $config_name already exists in flake.nix"
  fi
}

if is_nixos; then
  nixos_config="      $hostname = nixpkgs.lib.nixosSystem {
        system = \"x86_64-linux\";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/$hostname/configuration.nix
          ./hosts/$hostname/hardware-configuration.nix
        ] ++ profiles.baseline;
      };"
  add_config_to_flake "NixOS" "$hostname" "$nixos_config" "# end nixosConfigurations"
else
  home_manager_config="      \"$my_user@$hostname\" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./modules/system/allow-unfree
          ./modules/system/common-options
          ./modules/system/private/home
        ];
      };"
  add_config_to_flake "home-manager" "$my_user@$hostname" "$home_manager_config" "# end homeConfigurations"
fi

sops-add-user --file "/etc/nixos/nix-private/.sops.yaml"

git -C /etc/nixos/nix-config add -A
git -C /etc/nixos/nix-private add -A
