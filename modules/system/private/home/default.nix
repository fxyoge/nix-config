{ config, inputs, pkgs, ... }: {
  imports = [
    inputs.private.homeManagerModules.private
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/home/${config.fxy.user}/.ssh/id_ed25519" ];
  sops.age.keyFile = "/home/${config.fxy.user}/sops/age/keys.txt";
  sops.age.generateKey = true;
  home.packages = [
    pkgs.sops
  ];
}
