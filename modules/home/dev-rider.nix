_: let
  pname = "com.jetbrains.Rider";
in {
  services.flatpak.packages = [pname];

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

    Environment.FLATPAK_ENABLE_SDK_EXT = "dotnet8";
  };
}
