{ ... }: let
  pname = "io.mango3d.LycheeSlicer";
in {
  services.flatpak.packages = [ pname ];
  
  services.flatpak.overrides."${pname}" = {
    Context.filesystems = [
      "!home"
      "xdg-documents"
    ];
  };
}
