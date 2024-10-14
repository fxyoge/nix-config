{
  config,
  flake,
  pkgs,
  ...
}: {
  imports = [
    flake.modules.generic.system-allow-unfree
    flake.modules.generic.system-common-options
    flake.modules.generic.system-nix-github-token
    flake.modules.home.dev-jetbrains-toolbox
    flake.modules.home.dev-git
    flake.modules.home.dev-goland
    flake.modules.home.dev-localai-podman
    flake.modules.home.dev-vscode
    flake.modules.home.finance-finreport-collect
    flake.modules.home.finance-finreport-dl
    flake.modules.home.finance-finreport
    flake.modules.home.finance-hledger-merge
    flake.modules.home.games-bottles
    flake.modules.home.games-fjord-launcher
    flake.modules.home.games-lutris
    flake.modules.home.games-steam
    flake.modules.home.mail-thunderbird
    flake.modules.home.media-gimp
    flake.modules.home.media-hydrus
    flake.modules.home.media-inkscape
    flake.modules.home.media-lychee
    flake.modules.home.media-picard
    flake.modules.home.media-tauon
    flake.modules.home.rss-rssguard
    flake.modules.home.social-discord
    flake.modules.home.system-flatpak
    flake.modules.home.system-flatseal
    flake.modules.home.system-nix-inspect
    flake.modules.home.system-private
    flake.modules.home.terminal-text-processing
  ];

  fxy.hostname = "fxyoge-desktop";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  home.username = config.fxy.user;
  home.homeDirectory = "/home/${config.fxy.user}";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # i don't really know why i needed this, but https://www.reddit.com/r/NixOS/comments/182hvhf/a_corresponding_nix_package_must_be_specified_via/
  nix.package = pkgs.nix;
}
