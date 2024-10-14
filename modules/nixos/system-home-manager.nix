{ config, inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.fxyoge = {
    home.username = config.fxy.user;
    home.homeDirectory = "/home/${config.fxy.user}";
    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
  };
}
