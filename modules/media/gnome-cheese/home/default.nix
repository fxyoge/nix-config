# easiest way to check that my webcam works
{ ... }: let
  pname = "org.gnome.Cheese";
in {
  services.flatpak.packages = [ pname ];
}
