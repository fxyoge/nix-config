_: let
  pname = "org.gimp.GIMP";
in {
  services.flatpak.packages = [pname];
}
