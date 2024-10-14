_: let
  pname = "com.discordapp.Discord";
in {
  services.flatpak.packages = [pname];
}
