{ inputs, pkgs, ... }: {
  home-manager.users.fxyoge = {
    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
    services.flatpak.enable = true;
    services.flatpak.update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  # imports = [
  #   inputs.nix-flatpak.nixosModules.nix-flatpak
  # ];

           # gmodena/nix-flatpak #25


  # # System flatpaks are managed by nix. User flatpaks may be managed by
  # # the user, independent from nix, allowing for local builds and other
  # # experimentation/shenanigans.
  # services.flatpak.uninstallUnmanaged = true;
  
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
}
