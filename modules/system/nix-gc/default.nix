# Give nh a shot instead; it also has a garbage collection feature!
{ ... }: {
  nix.gc = {
    automatic = true;
    options = " --delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
  nix.optimise = {
    automatic = false;
    dates = [ "Weekly" ];
  };
}
