{ config, pkgs, ... }:
let
  mkDirs =
    defined:
    let
      home = config.home.homeDirectory;
      dirs = [
        "desktop"
        "documents"
        "download"
        "music"
        "pictures"
        "publicShare"
        "templates"
        "videos"
      ];
    in
    {
      enable = true;
      createDirectories = true;
    }
    // (builtins.listToAttrs (
      builtins.map (dir: {
        name = dir;
        value = if builtins.hasAttr dir defined then "${home}/${defined.${dir}}" else null;
      }) dirs
    ));
in
{
  imports = [
    ./modules/email
    ./modules/firefox
    ./modules/irc
    ./modules/mpd
    ./modules/ncmpcpp
    ./modules/neomutt
    ./modules/tmux
  ];

  home.packages = with pkgs.unstable; [
    clang
    element-desktop
    gimp
    gitu
    mpv
    pciutils
    tidal-dl
    yt-dlp
    zathura
  ];

  xdg = {
    enable = true;
    userDirs = mkDirs {
      documents = "documents";
      download = "downloads";
    };
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
