{ config, pkgs, ... }:
let
  mkDirs = defined:
    let
      home = config.home.homeDirectory;
      dirs = [ "desktop" "documents" "download" "music" "pictures" "publicShare" "templates" "videos" ];
    in
      builtins.listToAttrs (
        builtins.map (dir: {
          name = dir;
          value =
            if builtins.hasAttr dir defined then
              "${home}/${defined.${dir}}"
            else
              null;
        }) dirs
      );
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
    } // (mkDirs { documents = "documents"; download = "downloads"; });
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
