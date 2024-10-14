{ ... }: let
  pname = "com.github.tchx84.Flatseal";
in {
  services.flatpak.packages = [ pname ];
}
