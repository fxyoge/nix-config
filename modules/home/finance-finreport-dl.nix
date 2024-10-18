{
  config,
  perSystem,
  ...
}: {
  home.packages = [
    perSystem.self.finreport-dl
  ];
  xdg.configFile."finreport-dl/config.json".text = builtins.toJSON {
    keepass_db_path = config.fxy.paths.keepassVault;
    default_targets = config.fxy.finance.defaultTargets;
    inherit (config.fxy.finance) targets;
  };
}
