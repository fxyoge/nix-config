{ config, pkgs, ... }: {
  home.username = "fxyoge";
  home.homeDirectory = "/home/fxyoge";

  home.packages = with pkgs; [
    # secrets management
    keepassxc
    
    # misc
    neofetch
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # see: https://gitlab.com/usmcamp0811/dotfiles/-/blob/fb584a888680ff909319efdcbf33d863d0c00eaa/modules/home/apps/firefox/default.nix
  programs.firefox = {
    enable = true;
    profiles = {
      default = {


      };
    };
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

