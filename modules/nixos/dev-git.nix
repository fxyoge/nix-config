{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
  ];
  home-manager.users.fxyoge = import ../home/dev-git.nix;
}
