{ pkgs, ... }: {
  home.packages = with pkgs; [
    jq
    ripgrep
    yq-go
  ];
}
