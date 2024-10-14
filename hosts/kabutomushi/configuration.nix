{ config, flake, inputs, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # close enough
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t550

    flake.modules.generic.system-allow-unfree
    flake.modules.generic.system-common-options
    flake.modules.nixos.browser-firefox
    flake.modules.nixos.desktop-i3-xfce
    flake.modules.nixos.desktop-polybar
    flake.modules.nixos.desktop-rofi
    flake.modules.nixos.dev-git
    flake.modules.nixos.dev-misc
    flake.modules.nixos.dev-vim
    flake.modules.nixos.dev-vscode
    flake.modules.nixos.misc-keepass
    flake.modules.nixos.misc-neofetch
    flake.modules.nixos.misc-tree
    flake.modules.nixos.mail-thunderbird
    flake.modules.nixos.media-mpv
    flake.modules.nixos.media-tauon
    flake.modules.nixos.rss-rssguard
    flake.modules.nixos.system-bash
    flake.modules.nixos.system-flatpak
    flake.modules.nixos.system-flatseal
    flake.modules.nixos.system-home-manager
    flake.modules.nixos.system-locale
    flake.modules.nixos.system-misc
    flake.modules.nixos.system-nh
    flake.modules.nixos.system-nix-inspect
    flake.modules.nixos.system-pipewire
    flake.modules.nixos.system-private
    flake.modules.nixos.system-syncthing
    flake.modules.nixos.terminal-alacritty
    flake.modules.nixos.terminal-text-processing
    flake.modules.nixos.theme-cool
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

  fxy.hostname = "kabutomushi";
  networking.hostName = config.fxy.hostname;
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  # todo: what are you doing here
  programs.nm-applet.enable = true;

  home-manager.users.fxyoge = {
    home.stateVersion = "24.05";
  };
  system.stateVersion = "24.05";
}
