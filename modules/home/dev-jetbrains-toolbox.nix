# Don't forget to run the manual setup detailed here: https://nixos.wiki/wiki/Jetbrains_Tools
{pkgs, ...}: {
  home.packages = with pkgs; [jetbrains-toolbox];
}
