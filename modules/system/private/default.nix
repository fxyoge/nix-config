{ config, inputs, pkgs, ... }: {
  imports = [
    inputs.private.nixosModules.private
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    environment.systemPackages = with pkgs; [
      sops
    ];

    home-manager.sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    sops.defaultSopsFormat = "yaml";
    sops.age.sshKeyPaths = [ "/root/.ssh/id_ed25519" ];
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = true;

    home-manager.users.fxyoge = {
      sops.defaultSopsFormat = "yaml";
      sops.age.sshKeyPaths = [ "/root/.ssh/id_ed25519" ];
      sops.age.keyFile = "/var/lib/sops-nix/key.txt";
      sops.age.generateKey = true;
      home.packages = [
        (pkgs.writeShellScriptBin "sops-add-machine" ''
          set -eou pipefail

          hostname="${config.networking.hostName}"
          sops_yaml_path="/etc/nixos/nix-private/.sops.yaml"

          if [ ! -f "$sops_yaml_path" ]; then
              echo "$sops_yaml_path does not exist"
              exit 1
          fi

          echo "generating root ssh key"
          sudo ssh-keygen -t ed25519 -C "root@$hostname" -f "/root/.ssh/id_ed25519" -N ""

          age_public_key=$(sudo bash -c "${pkgs.ssh-to-age}/bin/ssh-to-age < /root/.ssh/id_ed25519.pub")

          echo "generating age key from ssh key"
          sudo mkdir -p /root/.config/sops/age
          sudo bash -c "${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /root/.ssh/id_ed25519 > /root/.config/sops/age/keys.txt"

          echo "adding host key to .sops.yaml"
          ${pkgs.yq-go}/bin/yq -i "
              .keys += \"$age_public_key\" |
              .keys[-1] anchor = \"$hostname\" |
              .creation_rules[0].key_groups[0].age += \"\" |
              .creation_rules[0].key_groups[0].age[-1] alias = \"$hostname\"
          " "$sops_yaml_path"

          echo "done! remember to run ./updatekeys.sh from another host to encrypt all secrets for this new host"
        '')
      ];
    };
  };
}
