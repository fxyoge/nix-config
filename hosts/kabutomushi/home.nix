{ config, pkgs, ... }: {
  home.username = "fxyoge";
  home.homeDirectory = "/home/fxyoge";

  home.packages = with pkgs; [
    # networking stuff
    mtr
    
    # secrets management
    keepassxc
    
    # misc
    neofetch
    cowsay
    jq
    yq-go
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

  programs.git = {
    enable = true;
    userName = "fxyoge";
    userEmail = "peanut@fxyoge.com";
  };

  # see: https://github.com/K1aymore/Nixos-Config/blob/master/packages/coding.nix
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
      bungcip.better-toml
      jnoortheen.nix-ide
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # {
      #   name = "codeium";
      #   publisher = "Codeium";
      #   version = "1.10.6";
      #   sha256 = "sha256-gQ9p2zDvimGWQV8NZx2/BlNBbj8yU/BWJZTgPlq3yck=";
      # }
      {
        name = "project-manager";
        publisher = "alefragnani";
        version = "12.8.0";
        sha256 = "sha256-sNiDyWdQ40Xeu7zp1ioRCi3majrPshlVbUSV2klr4r4=";
      }
    ];

    userSettings = {
      # "codeium.enableConfig" = {
      #   "*" = true;
      #   "nix" = true;
      # };
      
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "nixpkgs-fmt";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
        };
      };
    };
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

