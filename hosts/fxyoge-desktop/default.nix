{ config, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  home.username = config.fxy.user;
  home.homeDirectory = "/home/${config.fxy.user}";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # i don't really know why i needed this, but https://www.reddit.com/r/NixOS/comments/182hvhf/a_corresponding_nix_package_must_be_specified_via/
  nix.package = pkgs.nix;
}
