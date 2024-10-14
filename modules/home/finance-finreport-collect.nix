{
  config,
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.finreport-collect.packages.${pkgs.system}.default
  ];

  sops.secrets.finreportCollectConfig =
    config.fxy.secrets.finreportCollectConfig
    // {
      path = "/home/${config.fxy.user}/.config/finreport-collect/config.yaml";
    };
}
