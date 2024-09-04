{ pkgs, ... }: {
  home.packages = with pkgs; [
    jq
    yq-go
  ];
}
