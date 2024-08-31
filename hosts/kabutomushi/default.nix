{ config, inputs, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # close enough
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t550
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
  boot.loader.grub.enableCryptodisk = true;
  
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/${config.fxy.disks.kabutomushi.ssd.uuid}";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."luks-${config.fxy.disks.kabutomushi.luks.uuid}" = {
    keyFile = "/crypto_keyfile.bin";
    device = "/dev/disk/by-uuid/${config.fxy.disks.kabutomushi.luks.uuid}";
  };

  # todo: living life on the edge
  swapDevices = [ ];

  networking.hostName = "kabutomushi";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  # todo: what are you doing here
  programs.nm-applet.enable = true;

  home-manager.users.fxyoge = {
    home.stateVersion = "24.05";
  };
  system.stateVersion = "24.05";
}
