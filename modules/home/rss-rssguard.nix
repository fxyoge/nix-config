{ ... }: let
  pname = "io.github.martinrotter.rssguard";
in {
  services.flatpak.packages = [ pname ];

  services.flatpak.overrides."${pname}" = {
    Context.filesystems = [
      "xdg-config/autostart"
    ];
  };
}
