{
  pkgs,
  ...
}:
{
  services.dunst = {
    enable = true;
    package = pkgs.unstable.dunst;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        frame_color = "#2c363c";
        font = "Aporetic Sans Mono 12";
      };
      urgency_normal = {
        background = "#37474f";
        foreground = "eceff1";
        timeout = 5;
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.unstable.papirus-icon-theme;
      size = "16x16";
    };
  };
}
