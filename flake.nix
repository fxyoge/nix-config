{
  description = "Nix flake entrypoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-personal.url = "github:fxyoge/nixpkgs";

    arkenfox.url = "github:arkenfox/user.js";
    arkenfox.flake = false;

    finreport-collect.url = "git+ssh://git@github.com/fxyoge/finreport-collect.git";
    finreport-collect.inputs.flake-utils.follows = "flake-utils";
    finreport-collect.inputs.nixpkgs.follows = "nixpkgs";

    finreport-dl.url = "git+ssh://git@github.com/fxyoge/finreport-dl.git";
    finreport-dl.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons-rycee.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons-rycee.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    
    hledger-merge.url = "github:fxyoge/hledger-merge";
    hledger-merge.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";

    private.url = "git+file:///etc/nixos/nix-private";
    private.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-personal,
    arkenfox,
    finreport-collect,
    finreport-dl,
    firefox-addons-rycee,
    flake-utils,
    hledger-merge,
    home-manager,
    nix-flatpak,
    nixos-hardware,
    sops-nix,
    stylix,
    private,
    ...
  }: let
    profiles = {
      baseline = [
        ./modules/browser/firefox
        ./modules/dev/git
        ./modules/dev/misc
        ./modules/dev/vim
        ./modules/dev/vscode
        ./modules/misc/keepass
        ./modules/misc/neofetch
        ./modules/misc/tree
        ./modules/mail/thunderbird
        ./modules/media/mpv
        ./modules/media/tauon
        ./modules/rss/rssguard
        ./modules/system/allow-unfree
        ./modules/system/bash
        ./modules/system/common-options
        ./modules/system/flatpak
        ./modules/system/flatseal
        ./modules/system/home-manager
        ./modules/system/locale
        ./modules/system/misc
        ./modules/system/nh
        ./modules/system/nix-inspect
        ./modules/system/private
        ./modules/system/syncthing
        ./modules/terminal/alacritty
        ./modules/terminal/text-processing
      ];
    };
  in {
    nixosConfigurations = {
      ageha = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ageha
          ./modules/games/steam
          ./modules/system/pipewire
        ] ++ profiles.baseline;
      };

      kabutomushi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/kabutomushi
          ./modules/desktop/i3-xfce
          ./modules/desktop/polybar
          ./modules/desktop/rofi
          ./modules/system/pipewire
          ./modules/theme/cool
        ] ++ profiles.baseline;
      };
    }; # end nixosConfigurations

    homeConfigurations = {
      "fxyoge@fxyoge-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./hosts/fxyoge-desktop
          ./modules/dev/jetbrains-toolbox/home
          ./modules/dev/git/home
          ./modules/dev/goland/home
          ./modules/dev/localai-podman/home
          ./modules/dev/vscode/home
          ./modules/finance/finreport-collect/home
          ./modules/finance/finreport-dl/home
          ./modules/finance/finreport/home
          ./modules/finance/hledger-merge/home
          ./modules/games/bottles/home
          ./modules/games/fjord-launcher/home
          ./modules/games/lutris/home
          ./modules/games/steam/home
          ./modules/mail/thunderbird/home
          ./modules/media/gimp/home
          ./modules/media/hydrus/home
          ./modules/media/inkscape/home
          ./modules/media/lychee/home
          ./modules/media/picard/home
          ./modules/media/tauon/home
          ./modules/rss/rssguard/home
          ./modules/social/discord/home
          ./modules/system/allow-unfree
          ./modules/system/common-options
          ./modules/system/flatpak/home
          ./modules/system/flatseal/home
          ./modules/system/nix-inspect/home
          ./modules/system/nix-github-token
          ./modules/system/private/home
          ./modules/terminal/text-processing/home
        ];
      };
    }; # end homeConfigurations
  } //
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      pkgs-personal = import nixpkgs-personal { inherit system; };
    in {
      packages = {
        ensure-repo-exists = pkgs.callPackage ./packages/ensure-repo-exists {};
        hledger-flow-wrap = pkgs-personal.callPackage ./packages/hledger-flow-wrap { inherit pkgs-personal; };
        hledger-flow-xlsx2csv = pkgs.callPackage ./packages/hledger-flow-xlsx2csv {};
        setup-nixos = pkgs.callPackage ./packages/setup-nixos {};
        sops-add-host = pkgs.callPackage ./packages/sops-add-host {};
        sops-add-user = pkgs.callPackage ./packages/sops-add-user {};
        sops-update-keys = pkgs.callPackage ./packages/sops-update-keys {};
      };
    });
}
