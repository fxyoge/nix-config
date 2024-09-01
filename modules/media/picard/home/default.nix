{ ... }: let
  pname = "org.musicbrainz.Picard";
in {
  services.flatpak.packages = [ pname ];
}
