{ inputs, pkgs, ... }: {
  home.packages = [
    inputs.finreport-collect.packages.${pkgs.system}.default
  ];
}
