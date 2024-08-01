{ pkgs, inputs, ... }: {
  imports = [
    ../../modules/vscode
    inputs.nix-colors.homeManagerModules.default
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    nil # nix language server
  ];
  environment.variables = {
    EDITOR = "vim";
  };
  fxy.vscode.enable = true;
  home-manager.users.fxyoge = {
    home.packages = with pkgs; [
      mtr # network tracing tool
      jq
      yq-go
    ];
    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "fxyoge";
      userEmail = "peanut@fxyoge.com";
    };
  };
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
}
