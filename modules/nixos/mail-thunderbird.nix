_: {
  home-manager.users.fxyoge = import ../home/mail-thunderbird.nix;

  xdg.mime.defaultApplications = {
    "x-scheme-handler/mailto" = ["thunderbird.desktop"];
    "x-scheme-handler/mid" = ["thunderbird.desktop"];
    "message/rfc822" = ["thunderbird.desktop"];
  };
}
