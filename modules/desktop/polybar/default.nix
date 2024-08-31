{ config, ... }:
  let
    stylixCfg = config.stylix;
    stylixLib = config.lib.stylix;
  in
{
  home-manager.users.fxyoge = {
    systemd.user.services.polybar = {
      Install.WantedBy = [ "graphical-session.target" ];
    };
    services.polybar = {
      enable = true;

      # package = nixpkgs-unstable.polybar.override {
      #   alsaSupport = true;
      #   githubSupport = true;
      #   mpdSupport = true;
      #   pulseSupport = true;
      #   i3GapsSupport = true;
      # };

      config = let
        background = stylixLib.colors.base00;
        foreground = "#ffdddddd";
        foreground-alt = "#ffdddddd";
        primary = "#ff006633";
        secondary = "#ff003333";

        fonts = {
          font-0 = "${stylixCfg.fonts.monospace.name}:pixelsize=12;2";
          font-1 = "${stylixCfg.fonts.sansSerif.name}:pixelsize=12;0";
          font-2 = "${stylixCfg.fonts.emoji.name}:pixelsize=12;0";
        };
      in {
        "bar/main" = fonts // {
          monitor = "\${env:MONIpolybar tray emptyTOR}";
          height = 22;
          radius = 0;
          fixed-center = true;
          bottom = true;

          background = background;
          foreground = foreground;

          line-size = 2;
          line-color = "#f00";

          border-size = 0;

          padding-left = 0;
          padding-right = 0;

          module-margin-left = 0;
          module-margin-right = 0;

          modules-left = "i3";
          modules-center = "xwindow";
          modules-right = "tray sp cpu memory filesystem sp battery sp date sp";

          scroll-up = "i3wm-wsnext";
          scroll-down = "i3wm-wsprev";
        };

        "settings" = {
          screenchange-reload = "true";
          pseudo-transparency = true;
        };

        "global/wm" = {
          margin-top = 2;
          margin-bottom = 2;
        };

        "module/sl" = {
          type = "custom/text";
          label = "/";
        };

        "module/sp" = {
          type = "custom/text";
          label = " ";
        };

        "module/tray" = {
          type = "internal/tray";
          format = "<tray>";
          tray-spacing = 5;
        };

        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:120:...%";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 5;

          label = "C";
          format = "<label>";
          format-foreground = stylixLib.colors.green;

          warn-percentage = 80;
          label-warn = "C[%percentage%%]";
          format-warn = "<label-warn>";
          format-warn-foreground = stylixLib.colors.red;
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 5;

          label = "R";
          format = "<label>";
          format-foreground = stylixLib.colors.green;

          warn-percentage = 80;
          label-warn = "R[%gb_used%/%gb_total% GB]";
          format-warn = "<label-warn>";
          format-warn-foreground = stylixLib.colors.red;
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;

          # Only show workspaces on the same output as the bar
          pin-workspaces = true;

          label-mode-padding = 2;
          label-mode-foreground = "#000";
          label-mode-background = primary;

          # focused = "Active workspace on focused monitor";
          label-focused = "%index%";
          label-focused-background = primary;
          label-focused-padding = 2;

          # unfocused = "Inactive workspace on any monitor";
          label-unfocused = "%index%";
          label-unfocused-background = background;
          label-unfocused-padding = 2;

          # visible = "Active workspace on unfocused monitor";
          label-visible = "%index%";
          label-visible-background = secondary;
          label-visible-padding = 2;

          # urgent = "Workspace with urgency hint set";
          label-urgent = "%index%";
          label-urgent-background = stylixLib.colors.red;
          label-urgent-padding = 2;

          label-separator = "|";
          label-separator-padding = 2;
          label-separator-foreground = "#ffb52a";
        };

        "module/filesystem" = {
          type = "internal/fs";
          interval = 60;

          mount-0 = "/";

          label-mounted = "D";
          format-mounted = "<label-mounted>";
          format-mounted-foreground = stylixLib.colors.green;

          warn-percentage = 80;
          label-warn = "D[%used%/%total%]";
          format-warn = "<label-warn>";
          format-warn-foreground = stylixLib.colors.red;
        };

        "module/volume" = {
          type = "internal/volume";
          format-volume = "<label-volume> <bar-volume>";
          label-volume = "VOL";
          label-volume-foreground = foreground;

          format-muted-prefix = " ";
          format-muted-foreground = foreground-alt;
          label-muted = "sound muted";

          bar-volume-width = "10";
          bar-volume-foreground-0 = "#55aa55";
          bar-volume-foreground-1 = "#55aa55";
          bar-volume-foreground-2 = "#55aa55";
          bar-volume-foreground-3 = "#55aa55";
          bar-volume-foreground-4 = "#55aa55";
          bar-volume-foreground-5 = "#f5a70a";
          bar-volume-foreground-6 = "#ff5555";
          bar-volume-gradient = true;
          bar-volume-indicator = "|";
          bar-volume-indicator-font = "2";
          bar-volume-fill = "─";
          bar-volume-fill-font = "2";
          bar-volume-empty = "─";
          bar-volume-empty-font = "2";
          bar-volume-empty-foreground = foreground-alt;
        };

        "module/eth" = {
          type = "internal/network";
          interval = 15;
          interface-type = "wired";

          label-connected = "E";
          format-connected = "<label-connected>";
          format-connected-foreground = stylixLib.colors.green;
          
          label-disconnected = "E";
          format-disconnected = "<label-disconnected>";
          format-disconnected-foreground = stylixLib.colors.orange;
        };

        "module/wlan" = {
          type = "internal/network";
          interval = 15;
          interface-type = "wireless";

          label-connected = "W";
          format-connected = "<label-connected>";
          format-connected-foreground = stylixLib.colors.green;

          label-disconnected = "W";
          format-disconnected = "<label-disconnected>";
          format-disconnected-foreground = stylixLib.colors.orange;
        };

        "module/date" = {
          type = "internal/date";
          interval = "5";

          date = "%Y-%m-%d";
          time = "%H:%M";

          label = "%date% %time%";
        };

        "module/temperature" = {
          type = "internal/temperature";
          thermal-zone = "0";
          warn-temperature = "60";

          format-underline = "#0561E8";
          format = "<ramp> <label>";
          format-warn-underline = "#0561E8";
          format-warn = "<ramp> <label-warn>";

          label = "%temperature-c%";
          label-warn = "%temperature-c%";
          label-warn-foreground = secondary;

          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-foreground = foreground-alt;
        };

        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist-0 = "num lock";

          format-prefix = " ";
          format-prefix-foreground = foreground-alt;

          label-layout = "%layout%";

          label-indicator-padding = "2";
          label-indicator-margin = "1";
          label-indicator-background = secondary;
        };

        "module/xbacklight" = {
          type = "internal/xbacklight";

          format = "<label> <bar>";
          label = "BL";

          bar-width = "10";
          bar-indicator = "|";
          bar-indicator-foreground = "#ff";
          bar-indicator-font = "2";
          bar-fill = "─";
          bar-fill-font = "2";
          bar-fill-foreground = "#9f78e1";
          bar-empty = "─";
          bar-empty-font = "2";
          bar-empty-foreground = foreground-alt;
        };

        "module/backlight-acpi" = {
          "inherit" = "module/xbacklight";
          type = "internal/backlight";
          card = "intel_backlight";
        };

        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
          full-at = "95";
          low-at = "20";

          label-full = "B";
          format-full = "<label-full>";
          format-full-foreground = stylixLib.colors.green;

          label-charging = "B[%percentage%%++]";
          format-charging = "<label-charging>";
          format-charging-foreground = stylixLib.colors.orange;

          label-discharging = "B[%percentage%%]";
          format-discharging = "<label-discharging>";
          format-discharging-foreground = stylixLib.colors.orange;

          label-low = "B[%percentage%%]";
          format-low = "<label-low>";
          format-low-foreground = stylixLib.colors.red;
        };

        "module/powermenu" = {
          type = "custom/menu";

          format-spacing = "1";

          label-open = "";
          label-open-foreground = secondary;
          label-close = " cancel";
          label-close-foreground = secondary;
          label-separator = "|";
          label-separator-foreground = foreground-alt;

          menu-0-0 = "reboot";
          menu-0-0-exec = "menu-open-1";
          menu-0-1 = "power off";
          menu-0-1-exec = "menu-open-2";

          menu-1-0 = "cancel";
          menu-1-0-exec = "menu-open-0";
          menu-1-1 = "reboot";
          menu-1-1-exec = "systemctl reboot";

          menu-2-0 = "power off";
          menu-2-0-exec = "systemctl poweroff";
          menu-2-1 = "cancel";
          menu-2-1-exec = "menu-open-0";
        };
      };
      script = ''
        polybar main &
      '';
    };
  };
}
