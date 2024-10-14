{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "fxyoge";
    userEmail = "peanut@fxyoge.com";

    aliases = {
      c = "checkout";
      cb = "checkout -b";

      lsb = "branch --list";
      lsr = "remote -v";

      rmb = "branch -d";
      rmbb = "branch -D";

      s = "status --show-stash";

      chk = "stash --include-untracked";
      uchk = "stash pop";
    };
  };
}
