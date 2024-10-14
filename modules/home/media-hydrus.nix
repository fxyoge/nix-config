{ ... }: let
  pname = "io.github.hydrusnetwork.hydrus";
in {
  services.flatpak.packages = [ pname ];

  services.flatpak.overrides."${pname}" = {
    Context.filesystems = [
      "~/Downloads"
      "~/Pictures"
    ];
    Context.persistent = [
      "Hydrus"
    ];
  };
}
