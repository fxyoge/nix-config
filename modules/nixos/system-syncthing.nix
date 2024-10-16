{
  config,
  lib,
  ...
}: {
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    inherit (config.fxy) user;

    configDir = "/home/${config.fxy.user}/.config/syncthing";
    dataDir = "/home/${config.fxy.user}/.local/share/syncthing";

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices =
        builtins.mapAttrs (_name: value: {
          id = value;
        })
        config.fxy.syncthing.devices;
      folders =
        lib.filterAttrs (
          _name: value:
            lib.elem config.networking.hostName value.devices
        )
        config.fxy.syncthing.folders;
    };
  };
}
