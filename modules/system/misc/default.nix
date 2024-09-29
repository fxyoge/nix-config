{ config, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  users.users.${config.fxy.user} = {
    isNormalUser = true;
    description = config.fxy.user;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
