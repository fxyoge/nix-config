{ lib, ... }: {
  # TODO: move all options from nix-private into here
  options = {
    fxy.finance.defaultTargets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    fxy.finance.targets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          env = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule {
              options = {
                entry = lib.mkOption {
                  type = lib.types.str;
                };
                field = lib.mkOption {
                  type = lib.types.str;
                };
                type = lib.mkOption {
                  type = lib.types.enum [ "raw" "podmanSecret" ];
                  default = "raw";
                };
              };
            });
            default = {};
          };
        };
      });
      default = {};
    };
  };
}
