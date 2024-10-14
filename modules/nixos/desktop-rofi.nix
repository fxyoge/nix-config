{pkgs, ...}: {
  home-manager.users.fxyoge = {
    home.packages = with pkgs; [
      rofi-power-menu
    ];
    programs.rofi = {
      enable = true;
    };
  };
}
