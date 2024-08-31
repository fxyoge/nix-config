{ ... }: let
  pname = "com.valvesoftware.Steam";
in {
  services.flatpak.packages = [ pname ];
}
