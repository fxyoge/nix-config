{ config, pkgs, ... }: {
  environment.xfce.excludePackages = with pkgs; [
    xfce.parole
  ];
  services.displayManager.defaultSession = "none+i3";
  services.picom = {
  #  enable = true;
    settings = {
      inactive-opacity = 0.9;
      active-opacity = 1;
      inactive-opacity-override = true;
      blur-background = true;
      blur-strength = 9;
      opacity-rule = [];
    };
  };
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    desktopManager.xfce.enable = true;
    desktopManager.xfce.noDesktop = true;
    desktopManager.xfce.enableXfwm = false;
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
  };
  
  home-manager.users.fxyoge = {
    xsession.windowManager.i3 = let mod = "Mod4"; in {
      enable = true;
      config = {
        bars = [];
        modifier = mod;
        floating.modifier = mod;
        defaultWorkspace = "workspace number 1";
        modes.resize = {
          "Left" = "resize shrink width 10 px or 1 ppt";
          "Down" = "resize grow height 10 px or 1 ppt";
          "Up" = "resize shrink height 10 px or 1 ppt";
          "Right" = "resize grow width 10 px or 1 ppt";
          "Escape" = "mode default";
          "Return" = "mode default";
          "${mod}+r" = "mode default";
        };
        keybindings = {
          "${mod}+Shift+q" = "kill";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+v" = "split v";

          "${mod}+Shift+s" = "layout stacking";
          "${mod}+Shift+w" = "layout tabbed";
          "${mod}+Shift+e" = "layout toggle split";

          "${mod}+Shift+space" = "floating toggle";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";
          "${mod}+minus" = "workspace number 11";
          "${mod}+equal" = "workspace number 12";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";
          "${mod}+Shift+underscore" = "move container to workspace number 11";
          "${mod}+Shift+plus" = "move container to workspace number 12";

          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+r" = "mode resize";

          "${mod}+Return" = "exec ${config.home-manager.users.fxyoge.xsession.windowManager.i3.config.terminal}";
          # this will definitely break in the future, if i ever choose not to use rofi (or rofi-power-menu, for that matter)
          "${mod}+space" = "exec \"${builtins.replaceStrings ["\""] ["\\\\\""] (builtins.concatStringsSep " " [
            "XDG_DATA_DIRS=\"\${XDG_DATA_DIRS}:/var/lib/flatpak/exports/share\""
            "rofi"
            "-show drun"
            "-modi p:'rofi-power-menu --symbols-font \"${config.fxy.fonts.symbols}\"'"
            "-show-icons"
          ])}\"";
        };
      };
    };
  };
}
