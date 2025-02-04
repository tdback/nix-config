{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
in
{
  # Enable xmonad and xmonad-contrib.
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
      haskellPackages.xmonad_0_18_0
      haskellPackages.xmonad-contrib_0_18_1
    ];
  };

  # Enable xmobar, which will be started from xmonad.
  programs.xmobar = {
    enable = true;
    package = pkgs.unstable.xmobar;
    extraConfig =
      let
        volume = lib.getExe pkgs.unstable.pavucontrol;
      in
      ''
        Config
          { font             = "JetBrainsMono Nerd Font 9"
          , allDesktops      = True
          , hideOnStart      = False
          , lowerOnStart     = True
          , overrideRedirect = True
          , persistent       = True
          , sepChar          = "%"
          , alignSep         = "}{"
          , template         = "%XMonadLog%}%time%{<action=`${volume}` button=1>%default:Master%</action> | %cpu% | %memory% | %date% "
          , commands         =
              [ Run Cpu ["-t", "CPU: <total>%"] 10
              , Run Memory ["-t", "RAM: <usedratio>%"] 10
              , Run Date "%m.%d.%Y" "date" 10
              , Run Date "%H:%M" "time" 10
              , Run Volume "default" "Master" ["-t", "VOL: <volume>%"] 10
              , Run XMonadLog
              ]
          }
      '';
  };

  # Generate X11 init scripts.
  home.file = with pkgs.unstable; {
    ".xinitrc".text = ''
      [ -f ~/.xprofile ] && . ~/.xprofile
      [ -f ~/.Xresources ] && ${getExe xorg.xrdb} -merge ~/.Xresources
      exec xmonad
    '';
    ".xprofile".text = ''
      ${getExe xorg.setxkbmap} -layout us
      ${getExe xorg.xrandr} --output DP-0 --primary --mode 1920x1080 --rotate normal --rate 165
      ${getExe xorg.xset} r rate 350 40
      ${getExe xorg.xsetroot} -cursor_name left_ptr
      ~/.fehbg
    '';
    ".Xresources".text = "Xcursor.size: 24";
  };

  # Include these packages.
  home.packages = with pkgs.unstable; [
    pamixer
  ];
}
