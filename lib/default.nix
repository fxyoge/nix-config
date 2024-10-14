{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  homeConfigurations = usersPath: let
    usersPathStr = toString usersPath;

    userDirs = builtins.attrNames (
      lib.filterAttrs (_: type: type == "directory") (builtins.readDir usersPathStr)
    );

    mkConfigurations = system: 
      lib.genAttrs userDirs (
        name:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            modules = [
              "${usersPathStr}/${name}/home.nix"
            ];

            extraSpecialArgs = {
              inherit inputs system;
              flake = inputs.self;
              perSystem =
                lib.mapAttrs (
                  _: flake: flake.legacyPackages.${system} or {} // flake.packages.${system} or {}
                )
                inputs;
            };
          }
      );

    configurations = lib.foldl' lib.mergeAttrs {} (map mkConfigurations (import inputs.systems));

    # Generate checks for each configuration
    mkChecks = system: lib.mapAttrs' (name: config:
      lib.nameValuePair "home-manager-${name}" (
        config.activationPackage
      )
    ) (mkConfigurations system);

  in {
    inherit configurations;
    checks = lib.genAttrs (import inputs.systems) mkChecks;
  };
}
