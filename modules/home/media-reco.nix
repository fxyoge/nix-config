{ ... }: let
  pname = "com.github.ryonakano.reco";
in {
  services.flatpak.packages = [ pname ];
}
