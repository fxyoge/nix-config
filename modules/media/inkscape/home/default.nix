{ ... }: let
  pname = "org.inkscape.Inkscape";
in {
  services.flatpak.packages = [ pname ];
  
  services.flatpak.overrides."${pname}" = {
    Context.filesystems = [
      "!host;xdg-pictures"
    ];
  };
}
