{ pkgs, ... }: {
  home-manager.users.fxyoge = {
    home.packages = [
      (pkgs.writeShellScriptBin "helloworld.sh" ''
        echo "hey there world"
      '')
    ];
  };
}
