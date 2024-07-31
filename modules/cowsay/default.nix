{ config, pkgs, lib, ... }: {
  options = {
    fxy.cowsay.users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };
  config = {
    home-manager.users = lib.listToAttrs (
      map (user: {
        name = user;
        value = { home.packages = [pkgs.cowsay]; };
      }) config.fxy.cowsay.users);
  };
}
