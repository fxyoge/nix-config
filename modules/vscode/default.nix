{ config, pkgs, lib, ... }:
  let
    cfg = config.fxy.vscode;
  in
{
  options = {
    fxy.vscode.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nil # nix language server
    ];
    home-manager.users.fxyoge = {
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
    };
  };
}
