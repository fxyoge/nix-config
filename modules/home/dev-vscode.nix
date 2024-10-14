{ pkgs, ... }: {
  # nix language server, used for the nix-ide extension
  home.packages = with pkgs; [ nil ];
  
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
      {
        name = "project-manager";
        publisher = "alefragnani";
        version = "12.8.0";
        sha256 = "sha256-sNiDyWdQ40Xeu7zp1ioRCi3majrPshlVbUSV2klr4r4=";
      }
      {
        name = "vscode-task-manager";
        publisher = "cnshenj";
        version = "1.0.0";
        sha256 = "sha256-/eXJ3PPV/a1bD4TX3Bzo1CH5nXD1LvTtXUfsLVuU2Nc=";
      }
    ];

    userSettings = {
      "explorer.confirmDragAndDrop" = false;
      "extensions.ignoreRecommendations" = true;
      "git.confirmSync" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "nixpkgs-fmt";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
        };
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "workbench.startupEditor" = "none";
    };
  };
}
