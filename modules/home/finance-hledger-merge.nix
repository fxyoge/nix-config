{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.hledger-merge.packages.${pkgs.system}.default
  ];
}
