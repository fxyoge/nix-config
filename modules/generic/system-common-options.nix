{lib, ...}: {
  # TODO: move all options from nix-private into here
  options = {
    fxy.disks = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
    };
    fxy.hostname = lib.mkOption {
      type = lib.types.str;
    };
    fxy.user = lib.mkOption {
      type = lib.types.str;
    };
    fxy.timezone = lib.mkOption {
      type = lib.types.str;
    };
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
                  type = lib.types.enum ["raw" "podmanSecret"];
                  default = "raw";
                };
              };
            });
            default = {};
          };
          arguments = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = {};
          };
        };
      });
      default = {};
    };
    fxy.secrets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          sopsFile = lib.mkOption {
            type = lib.types.path;
          };
          key = lib.mkOption {
            type = lib.types.str;
          };
        };
      });
    };
  };
}
