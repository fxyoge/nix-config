{
  description = "Nix flake entrypoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    privateRepo.url = "git+ssh://git@github.com/fxyoge/nix-private?ref=master";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, privateRepo, ... }: {
    nixosConfigurations = {
      kabutomushi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/kabutomushi/hardware-configuration.nix
          ./hosts/kabutomushi/configuration.nix
          ./modules/cowsay {
            fxy.cowsay.users = ["fxyoge"];
          }
          ./profiles/base
          ./profiles/dev-basics
          {
            home-manager.backupFileExtension = "bkp";
            home-manager.users.fxyoge = import ./hosts/kabutomushi/home.nix;
          }
        ];
      };
    };
  };
}

