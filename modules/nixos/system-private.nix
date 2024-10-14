{ inputs, pkgs, ... }: {
  imports = [
    inputs.private.modules.generic.private
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    environment.systemPackages = with pkgs; [
      sops
    ];

    home-manager.sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    sops.defaultSopsFormat = "yaml";
    sops.age.sshKeyPaths = [ "/root/.ssh/id_ed25519" ];
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = true;

    home-manager.users.fxyoge = {
      sops.defaultSopsFormat = "yaml";
      sops.age.sshKeyPaths = [ "/root/.ssh/id_ed25519" ];
      sops.age.keyFile = "/var/lib/sops-nix/key.txt";
      sops.age.generateKey = true;
    };
  };
}
