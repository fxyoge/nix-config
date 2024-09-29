{ ... }: {
  home-manager.users.fxyoge = import ./home;

  xdg.mime.defaultApplications = {
    "x-scheme-handler/mailto" = ["thunderbird.desktop"];
    "x-scheme-handler/mid" = ["thunderbird.desktop"];
    "message/rfc822" = ["thunderbird.desktop"];
  };
}
