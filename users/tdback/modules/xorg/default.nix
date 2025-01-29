{
  lib,
  pkgs,
  ...
}:
with pkgs.unstable;
let
  inherit (lib) getExe getExe';
in
{
  xsession.windowManager.bspwm = {
    enable = true;
    package = bspwm;
    settings =
      let
        border = "#16191F";
        feedback = "#485264";
      in
      {
        window_gap = 4;
        border_width = 1;
        top_padding = 2;
        bottom_padding = 2;
        right_padding = 2;
        left_padding = 2;
        top_monocle_padding = 0;
        bottom_monocle_padding = 0;
        right_monocle_padding = 0;
        left_monocle_padding = 0;
        split_ratio = 0.5;
        borderless_monocle = true;
        gapless_monocle = true;
        normal_border_color = border;
        active_border_color = border;
        focused_border_color = feedback;
      };

    rules = {
      "Zathura".state = "tiled";
    };

    startupPrograms = [
      "${getExe xorg.setxkbmap} -layout us"
      "${getExe xorg.xsetroot} -cursor_name left_ptr"
      "${getExe xorg.xset} r rate 350 40"
      "~/.fehbg"
    ];

    extraConfig = ''
      ${getExe' bspwm "bspc"} monitor -d 1 2 3 4 5 6 7 8 9
    '';
  };

  services.sxhkd = {
    enable = true;
    package = sxhkd;
    keybindings =
      let
        bspc = getExe' bspwm "bspc";
      in
      {
        # Program hotkeys.
        "alt + Tab" = "${getExe rofi} -show window";
        "super + r" = "${getExe rofi} -show drun";
        "super + x" = getExe alacritty;
        "super + b" = "$BROWSER";
        "super + p" = "snapshot -f";
        "super + shift + p" = "snapshot";
        "super + Escape" = "systemctl --user restart polybar";
        "super + alt + {q,r}" = "${bspc} {quit,wm -r}";

        # Function hotkeys.
        "XF86AudioPrev" = "${getExe mpc} prev";
        "XF86AudioNext" = "${getExe mpc} next";
        "XF86AudioPlay" = "${getExe mpc} toggle";
        "XF86AudioLowerVolume" = "${getExe pamixer} -d 5";
        "XF86AudioRaiseVolume" = "${getExe pamixer} -i 5";
        "XF86AudioMute" = "${getExe pamixer} -t";

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
        "super + alt + shift {h,j,k,l}" =
          "${bspc} node -z {right -20 0, top 0 20, bottom 0 -20, left 20 0}";
        "super + {Left,Down,Up,Right}" = "${bspc} node -v {-20 0,0 20,0 -20,20 0}";
      };
  };

  # Generate X11 init scripts.
  home.file = {
    ".xinitrc".text = ''
      [ -f ~/.xprofile ] && . ~/.xprofile
      [ -f ~/.Xresources ] && ${getExe xorg.xrdb} -merge ~/.Xresources
      exec ${getExe' bspwm "bspwm"}
    '';
    ".xprofile".text =
      "${getExe xorg.xrandr} --output DP-0 --primary --mode 1920x1080 --rotate normal --rate 165";
    ".Xresources".text = "Xcursor.size: 24";
  };
}
