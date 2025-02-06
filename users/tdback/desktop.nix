{
  config,
  pkgs,
  ...
}:
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
    ./modules/alacritty
    ./modules/dunst
    ./modules/emacs
    ./modules/email
    ./modules/firefox
    ./modules/mpd
    ./modules/ncmpcpp
    ./modules/rofi
    ./modules/tmux
    ./modules/xmonad
  ];

  home.packages = with pkgs.unstable; [
    clang
    deploy-rs
    feh
    gimp
    gitu
    hledger
    imagemagick
    mpv
    nixd
    pciutils
    (python312.withPackages (ps: with ps; [ uv ]))
    zathura
  ];

  xdg = {
    enable = true;
    userDirs = mkDirs {
      documents = "Documents";
      download = "Downloads";
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
