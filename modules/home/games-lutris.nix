_: let
  pname = "net.lutris.Lutris";
in {
  services.flatpak.packages = [pname];
}
