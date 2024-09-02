{ ... }: let
  pname = "com.valvesoftware.Steam";
in {
  services.flatpak.packages = [ pname ];
  
  services.flatpak.overrides."${pname}" = {
    Context.filesystems = [
      "!xdg-music;!xdg-pictures;!xdg-run/app/com.discordapp.Discord;/media/fxyoge/hdd1/steam"
    ];
  };
}
