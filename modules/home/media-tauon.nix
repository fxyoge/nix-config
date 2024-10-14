_: let
  pname = "com.github.taiko2k.tauonmb";
in {
  services.flatpak.packages = [pname];

  services.flatpak.overrides."${pname}" = {
    Context.filesystems = [
      "!xdg-run/discord-ipc-0"
      "!xdg-run/app/com.discordapp.Discord:create"
    ];
  };
}
