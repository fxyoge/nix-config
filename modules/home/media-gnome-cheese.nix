# easiest way to check that my webcam works
_: let
  pname = "org.gnome.Cheese";
in {
  services.flatpak.packages = [pname];
}
