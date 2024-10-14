{
  description = "Nix flake entrypoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    arkenfox.url = "github:arkenfox/user.js";
    arkenfox.flake = false;

    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

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

    systems.url = "github:nix-systems/default";

    private.url = "git+file:///etc/nixos/nix-private";
    private.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    slib = import ./lib {inherit inputs;};
    homeConfigurationsOutput = slib.homeConfigurations ./users;
  in
    lib.recursiveUpdate
    (inputs.blueprint {
      inherit inputs;
    })
    {
      homeConfigurations = homeConfigurationsOutput.configurations;
      inherit (homeConfigurationsOutput) checks;
    };
}
