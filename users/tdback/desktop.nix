{ config, pkgs, ... }:
let
  dirs = [ "desktop" "documents" "download" "music" "pictures" "publicShare" "templates" "videos" ];
  defined = {
    "documents" = "${config.home.homeDirectory}/documents";
    "download" = "${config.home.homeDirectory}/downloads";
  };
  userDirs =
    builtins.map (dir: { name = dir; value = defined.${dir} or null; }) dirs
    |> builtins.listToAttrs;
in
{
  imports = [
    ./modules/alacritty
    ./modules/dunst
    ./modules/email
    ./modules/firefox
    ./modules/irc
    ./modules/mpd
    ./modules/ncmpcpp
    ./modules/neomutt
    ./modules/polybar
    ./modules/rofi
    ./modules/tmux
    ./modules/x11
  ];

  home.packages = with pkgs.unstable; [
    clang
    feh
    (ffmpeg.override { withXcb = true; })
    flameshot
    gimp
    gitu
    mpc-cli
    mpv
    pavucontrol
    pamixer
    pciutils
    signal-desktop
    sxiv
    tidal-dl
    xclip
    yt-dlp
    zathura
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    } // userDirs;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
