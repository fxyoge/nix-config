{ pkgs, ... }: {
  home-manager.users.fxyoge = import ./home;
  
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
}
