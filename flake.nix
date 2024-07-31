{
  description = "Nix flake entrypoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    privateRepo.url = "git+ssh://git@github.com/fxyoge/nix-private?ref=master";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, privateRepo, ... }: {
    nixosConfigurations = {
      kabutomushi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { _module.args = { inherit inputs; }; }
          ./hosts/kabutomushi/hardware-configuration.nix
          ./hosts/kabutomushi/configuration.nix
          ./modules/cowsay {
            cowsay.users = ["fxyoge"];
          }
          home-manager.nixosModules.home-manager {
            home-manager.backupFileExtension = "bkp";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fxyoge = import ./hosts/kabutomushi/home.nix;
          }
        ];
      };
    };
  };
}

