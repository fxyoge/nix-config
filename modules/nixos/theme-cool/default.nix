{
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  backgroundPixelPkg =
    pkgs.runCommand "fxy-background-pixel-pkg" {
      buildInputs = [pkgs.imagemagick];
    } ''
      mkdir -p $out
      convert -size 1x1 xc:black background_pixel.png
      cp background_pixel.png $out
    '';
in {
  imports = [
    inputs.stylix.nixosModules.stylix
    ./rofi.nix
  ];

  options = with types; {
    fxy.fonts.symbols = mkOption {
      type = str;
    };
  };

  config = {
    fxy.fonts.symbols = "Symbols Nerd Font Mono";

    home-manager.users.fxyoge = {
      home.packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "NerdFontsSymbolsOnly"
          ];
        })
      ];
    };

    stylix = {
      enable = true;
      image = "${backgroundPixelPkg}/background_pixel.png";
      base16Scheme = ./tokyo-city-terminal-dark.yaml;
      fonts = {
        serif = {
          package = pkgs.roboto-serif;
          name = "Roboto Serif";
        };
        sansSerif = {
          package = pkgs.noto-fonts-cjk-sans;
          name = "Noto Sans CJK JP";
        };
        monospace = {
          package = pkgs.maple-mono;
          name = "Maple Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 10;
          terminal = 10;
        };
      };
    };
  };
}
