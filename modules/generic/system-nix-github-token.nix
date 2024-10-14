{config, ...}: {
  nix.extraOptions = ''
    !include ${config.sops.secrets.nixGithubAccessTokenConfig.path}
  '';
  sops.secrets.nixGithubAccessTokenConfig = config.fxy.secrets.nixGithubAccessTokenConfig;
}
