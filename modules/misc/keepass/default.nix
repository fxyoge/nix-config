{ pkgs, ... }: {
  home-manager.users.fxyoge = {
    home.packages = with pkgs; [
      keepassxc
    ];
  };
}
