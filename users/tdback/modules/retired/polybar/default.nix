{ lib, pkgs, ... }:
{
  services.polybar = {
    enable = true;
    package = pkgs.unstable.polybar.override { pulseSupport = true; };
    script = "polybar main &";
    settings =
      let
        colors = {
          alert = "#505050";
          foreground = "#F1F1F1";
          background = "#050505";
          background-alt = "#373B41";
        };
      in
      {
        "bar/main" = {
          bottom = true;
          width = "100%";
          height = "16pt";
          line.size = "3pt";
          font = [ "Iosevka Comfy Motion Fixed:size=8" ];

          foreground = "${colors.foreground}";
          background = "${colors.background}";

          separator = "|";
          padding = {
            left = 1;
            right = 1;
          };

          module.margin = 1;
          modules = {
            left = "bspwm";
            center = "time";
            right = "volume cpu memory date";
          };

          wm.restack = "bspwm";
          cursor.click = "pointer";
        };

        "module/bspwm" = {
          type = "internal/bspwm";
          pin.workspaces = true;
          label = {
            focused = {
              text = "%index%";
              foreground = "${colors.foreground}";
              padding = 1;
            };
            occupied = {
              text = "%index%";
              foreground = "${colors.alert}";
              padding = 1;
            };
            urgent = {
              text = "%index%";
              foreground = "${colors.foreground}";
              background = "${colors.background-alt}";
              padding = 1;
            };
            empty.text = "";
          };
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 3;
          label = "CPU %percentage%%";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 3;
          label = "RAM %percentage_used%%";
        };

        "module/volume" = {
          type = "internal/pulseaudio";
          label = {
            volume = "VOL %percentage%%";
            muted = "VOL 0%";
          };
          click.right = "${lib.getExe pkgs.pavucontrol}";
        };

        "module/time" = {
          type = "internal/date";
          interval = 1;
          label = "%time%";
          time = "%H:%M";
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;
          label = "%date%";
          date = "%m.%d.%Y";
        };

        "settings" = {
          screenchange.reload = true;
          pseudo.transparency = true;
        };
      };
  };

  # Make sure polybar starts only during graphical sessions.
  systemd.user.services.polybar.Install.WantedBy = [ "graphical-session.target" ];
}
