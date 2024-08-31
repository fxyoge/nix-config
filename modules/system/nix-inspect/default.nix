{ pkgs, ... }: {
  # The alternative is installing directly from bluskript/nix-inspect, but
  # for some reason this did not work out of the box for me.
  environment.systemPackages = with pkgs; [
    nix-inspect
  ];
}
