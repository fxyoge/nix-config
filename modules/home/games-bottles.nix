_: let
  pname = "com.usebottles.bottles";
in {
  services.flatpak.packages = [pname];
}
