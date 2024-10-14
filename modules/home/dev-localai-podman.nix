{ pkgs, ... }: let
  localai = (pkgs.writeShellScriptBin "localai" ''
    mkdir -p "$HOME/.local/share/localai/models"
    podman run -it \
      -p 9255:8080 \
      -v "$HOME/.local/share/localai/models:/build/models" \
      docker.io/localai/localai:latest-aio-cpu
  '');
in {
  home.packages = [
    localai
  ];
}
