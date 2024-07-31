{ config, pkgs, ... }: {
  options = {
    cowsay.users = pkgs.lib.mkOption {
      type = pkgs.lib.types.listOf pkgs.lib.types.str;
    };
  };
  config = {
    home-manager.users = pkgs.lib.listToAttrs (
      map (user: {
        name = user;
        value = { home.packages = [pkgs.cowsay]; };
      }) config.cowsay.users);
  };
}
