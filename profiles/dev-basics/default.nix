{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      git
      vim
      wget
      curl
      nil # nix language server
    ];
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
  };
}
