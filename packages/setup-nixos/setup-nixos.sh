set -eou pipefail

git clone git@github.com:fxyoge/nix-config.git
sudo mv nix-config /etc/nixos/nix-config

my_user=$(id -un)
my_group=$(id -gn)
hostname=$(hostname)

sudo chown $my_user:$my_group /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix

mkdir -p "/etc/nixos/nix-config/hosts/$hostname"
mv /etc/nixos/configuration.nix "/etc/nixos/nix-config/hosts/$hostname/configuration.nix"
mv /etc/nixos/hardware-configuration.nix "/etc/nixos/nix-config/hosts/$hostname/hardware-configuration.nix"

new_config="
    $hostname = nixpkgs.lib.nixosSystem {
      system = \"x86_64-linux\";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/$hostname/configuration.nix
        ./hosts/$hostname/hardware-configuration.nix
      ];
    };"

sed -i "/# end nixosConfigurations/i\\${new_config//$'\n'/\\n}" /etc/nixos/nix-config/flake.nix

git -C /etc/nixos/nix-config add -A
