{ ... }: let
  pname = "com.jetbrains.WebStorm";
in {
  services.flatpak.packages = [ pname ];

  services.flatpak.overrides."${pname}" = {
    Context.sockets = [
      "!ssh-auth"
    ];

    Context.devices = [
      "!all"
    ];

    Context.filesystems = [
      "!xdg-run/gnupg"
      "!xdg-run/keyring"
      "~/Repos"
    ];

    Context.persistent = [
      ".java"
    ];

    Environment.IDEA_PROPERTIES = "/app/bin/idea.properties";
  };
}
