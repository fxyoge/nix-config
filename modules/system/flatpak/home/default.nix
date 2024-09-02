{ inputs, ... }: {
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];
  
  services.flatpak.enable = true;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };

  services.flatpak.overrides.global = {
    Context.filesystems = [
      "!host"
      "!home"
    ];
  };
}
