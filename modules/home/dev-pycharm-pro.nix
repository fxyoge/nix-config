{ ... }: let
  pname = "com.jetbrains.PyCharm-Professional";
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
  };
}
