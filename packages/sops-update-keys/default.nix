{ pkgs, ... }: pkgs.writeShellScriptBin "sops-update-keys" ''
  set -eou pipefail

  secrets_path=/etc/nixos/nix-private/secrets

  find "$secrets_path" -type f -exec ${pkgs.sops}/bin/sops updatekeys {} ';'
''
