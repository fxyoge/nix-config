{ ... }: {
  config = {
    home-manager.users.fxyoge = {
      programs.alacritty = {
        enable = true;
      };
      xsession.windowManager.i3.config.terminal = "alacritty";
    };
  };
}
