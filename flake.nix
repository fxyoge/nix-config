{
  description = "Nix flake entrypoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    arkenfox.url = "github:arkenfox/user.js";
    arkenfox.flake = false;

    firefox-addons-rycee.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons-rycee.inputs.nixpkgs.follows = "nixpkgs";

    fjordlauncher.url = "github:unmojang/FjordLauncher";

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
    arkenfox,
    firefox-addons-rycee,
    fjordlauncher,
    home-manager,
    nix-flatpak,
    nixos-hardware,
    sops-nix,
    stylix,
    private,
    ...
  }: {
    nixosConfigurations = {
      kabutomushi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/kabutomushi
          ./modules/browser/firefox
          ./modules/desktop/i3-xfce
          ./modules/desktop/polybar
          ./modules/desktop/rofi
          ./modules/dev/git
          ./modules/dev/misc
          ./modules/dev/vim
          ./modules/dev/vscode
          ./modules/mail/thunderbird
          ./modules/media/mpv
          ./modules/media/tauon
          ./modules/misc/keepass
          ./modules/misc/neofetch
          ./modules/misc/textprocessing
          ./modules/misc/tree
          ./modules/rss/rssguard
          ./modules/system/allow-unfree
          ./modules/system/bash
          ./modules/system/cups
          ./modules/system/flatpak
          ./modules/system/flatseal
          ./modules/system/home-manager
          ./modules/system/misc
          ./modules/system/nh
          ./modules/system/nix-inspect
          ./modules/system/pipewire
          ./modules/system/private
          ./modules/system/syncthing
          ./modules/terminal/alacritty
          ./modules/theme/cool
        ];
      };
    };

    homeConfigurations = {
      "fxyoge@fxyoge-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./hosts/fxyoge-desktop
          ./modules/dev/goland/home
          ./modules/dev/localai-podman/home
          ./modules/dev/pycharm-pro/home
          ./modules/dev/rider/home
          ./modules/dev/vscode/home
          ./modules/dev/webstorm/home
          ./modules/finance/finreport-dl/home
          ./modules/finance/finreport/home
          ./modules/games/bottles/home
          ./modules/games/fjord-launcher/home
          ./modules/games/lutris/home
          ./modules/games/steam/home
          ./modules/mail/thunderbird/home
          ./modules/media/hydrus/home
          ./modules/media/inkscape/home
          ./modules/media/lychee/home
          ./modules/media/picard/home
          ./modules/media/tauon/home
          ./modules/misc/textprocessing/home
          ./modules/rss/rssguard/home
          ./modules/system/allow-unfree
          ./modules/system/common-options
          ./modules/system/flatpak/home
          ./modules/system/flatseal/home
          ./modules/system/nix-inspect/home
          ./modules/system/private/home
        ];
      };
    };
  };
}
