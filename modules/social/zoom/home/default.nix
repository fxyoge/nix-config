{ ... }: let
  pname = "us.zoom.Zoom";
in {
  services.flatpak.packages = [ pname ];
}
