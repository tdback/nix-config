{ lib, pkgs, ... }:
{
  xsession.windowManager.bspwm = {
    enable = true;
    package = pkgs.unstable.bspwm;
    settings = let color = "#3B4252"; in {
      window_gap = 0;
      top_padding = 0;
      bottom_padding = 0;
      right_padding = 0;
      left_padding = 0;
      top_monocle_padding = 0;
      bottom_monocle_padding = 0;
      right_monocle_padding = 0;
      left_monocle_padding = 0;
      split_ratio = 0.5;
      borderless_monocle = true;
      gapless_monocle = true;
      normal_border_color = color;
      active_border_color = color;
      focused_border_color = color;
    };

    rules = {
      "Zathura".state = "tiled";
    };

    startupPrograms = [
      "${lib.getExe pkgs.unstable.xorg.setxkbmap} -layout us"
      "${lib.getExe pkgs.unstable.xorg.xsetroot} -cursor_name left_ptr"
      "${lib.getExe pkgs.unstable.xorg.xset} r rate 350 40"
      "~/.fehbg"
    ];

    extraConfig = ''
      ${lib.getExe' pkgs.unstable.bspwm "bspc"} monitor -d 1 2 3 4 5 6 7 8 9
    '';
  };

  services.sxhkd = let bspc = lib.getExe' pkgs.unstable.bspwm "bspc"; in {
    enable = true;
    package = pkgs.unstable.sxhkd;
    keybindings = {
      # Program hotkeys.
      "alt + Tab" = "${lib.getExe pkgs.unstable.rofi} -show window";
      "super + r" = "${lib.getExe pkgs.unstable.rofi} -show drun";
      "super + x" = "${lib.getExe pkgs.unstable.alacritty}";
      "super + b" = "$BROWSER";
      "super + p" = "${lib.getExe pkgs.unstable.flameshot} full -p $HOME/.local/screenshots";
      "super + shift + p" = "${lib.getExe pkgs.unstable.flameshot} gui -p $HOME/.local/screenshots";
      "super + Escape" = "systemctl --user restart polybar";
      "super + alt + {q,r}" = "${bspc} {quit,wm -r}";

      # Function hotkeys.
      "XF86AudioPrev" = "${lib.getExe pkgs.unstable.mpc} prev";
      "XF86AudioNext" = "${lib.getExe pkgs.unstable.mpc} next";
      "XF86AudioPlay" = "${lib.getExe pkgs.unstable.mpc} toggle";
      "XF86AudioLowerVolume" = "${lib.getExe pkgs.unstable.pamixer} -d 5";
      "XF86AudioRaiseVolume" = "${lib.getExe pkgs.unstable.pamixer} -i 5";
      "XF86AudioMute" = "${lib.getExe pkgs.pamixer} -t";

      # Manipulate window manager.
      "super + q" = "${bspc} node -{c,k}";
      "super + f" = "${bspc} node focused.tiled -t fullscreen";
      "super + t" = "${bspc} node focused.fullscreen -t tiled";
      "super + shift + f" = "${bspc} node focused.tiled -t floating";
      "super + shift + t" = "${bspc} node focused.floating -t tiled";
      "super + {_,shift + }{h,j,k,l}" = "${bspc} node -{f,s} {west,south,north,east}";
      "super + {_,shift}c" = "${bspc} node -f {next,prev}.local.!hidden.window";
      "super + bracket{left,right}" = "${bspc} desktop -f {prev,next}.local";
      "super + {grave,Tab}" = "${bspc} {node,desktop} -f last";
      "super + {o,i}" = "${bspc} wm -h off; ${bspc} node {older,newer} -f; ${bspc} wm -h on";
      "super + {_,shift + }{1-9,0}" = "${bspc} {desktop -f, node -d} '^{1-9,10}'";
      "super + alt + {h,j,k,l}" = "${bspc} node -z {left -20 0, bottom 0 20, top 0 -20, right 20 0}";
      "super + alt + shift {h,j,k,l}" = "${bspc} node -z {right -20 0, top 0 20, bottom 0 -20, left 20 0}";
      "super + {Left,Down,Up,Right}" = "${bspc} node -v {-20 0,0 20,0 -20,20 0}";
    };
  };

  # Generate X11 init scripts.
  home.file = {
    ".xinitrc".text = ''
      [ -f ~/.xprofile ] && . ~/.xprofile
      [ -f ~/.Xresources ] && ${lib.getExe pkgs.unstable.xorg.xrdb} -merge ~/.Xresources
      exec ${lib.getExe' pkgs.unstable.bspwm "bspwm"}
    '';
    ".xprofile".text = ''
      ${lib.getExe pkgs.unstable.xorg.xrandr} --output DP-0 --primary --mode 1920x1080 --rotate normal --rate 165
    '';
    ".Xresources".text = ''
      Xcursor.size: 24
    '';
  };
}
