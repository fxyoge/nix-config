{ ... }: let
  pname = "io.github.martinrotter.rssguard";
in {
  services.flatpak.packages = [ pname ];
}
