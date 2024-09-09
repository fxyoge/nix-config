{ pkgs, ... }: pkgs.writeShellScriptBin "sops-update-keys" ''
  set -eou pipefail

  secrets_path=/etc/nixos/nix-private/secrets

  cd "$secrets_path"
  find . -type f -exec ${pkgs.sops}/bin/sops updatekeys {} ';'
''
