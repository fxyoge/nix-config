{ ... }: let
  pname = "org.unmojang.FjordLauncher";
in {
  services.flatpak.packages = [{ appId = pname; origin = "unmojang"; }];
}
