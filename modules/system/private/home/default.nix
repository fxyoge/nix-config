{ inputs, pkgs, ... }: {
  imports = [
    inputs.private.homeManagerModules.private
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/root/.ssh/id_ed25519" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  home.packages = [
    pkgs.sops
  ];
}
