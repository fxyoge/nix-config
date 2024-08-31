{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
  ];
  home-manager.users.fxyoge = {
    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "fxyoge";
      userEmail = "peanut@fxyoge.com";
    };
  };
}
