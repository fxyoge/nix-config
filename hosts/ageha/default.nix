{ config, inputs, lib, modulesPath, ... }: let 
  disks = config.fxy.disks.ageha;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "thunderbolt" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/${disks.ssd.uuid}";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/${disks.boot.uuid}";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  
  boot.initrd.luks.devices."luks-${disks.luks1.uuid}".device = "/dev/disk/by-uuid/${disks.luks1.uuid}";
  boot.initrd.luks.devices."luks-${disks.luks2.uuid}".device = "/dev/disk/by-uuid/${disks.luks2.uuid}";

  swapDevices = [{
    device = "/dev/disk/by-uuid/${disks.swap.uuid}";
  }];

  fxy.hostname = "ageha";
  networking.hostName = config.fxy.hostname;
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  system.stateVersion = "24.05";
  home-manager.users.fxyoge = {
    home.stateVersion = "24.05";
  };
}
