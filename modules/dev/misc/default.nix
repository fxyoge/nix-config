{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];
  home-manager.users.fxyoge = {
    home.packages = with pkgs; [
      mtr # network tracing tool
    ];
  };
}
