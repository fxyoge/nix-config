# nix-config

My personal nix config. Some of it is hidden in private repos.

## Setting up a new machine

```
nix run github:fxyoge/nix-config#setup-nixos
```

## Setting up sops-nix

```
# on NixOS
nix run .#sops-add-host

# using home-manager
nix run .#sops-add-user

# after key successfully added, go to an existing machine and do:
nix run .#sops-update-keys
```

## Updating secrets

```
nix run nixpkgs#sops -- secrets/myfile.yaml
```
