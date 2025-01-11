{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.unstable.rofi;
    font = "Iosevka Comfy Motion Fixed 12";
    location = "center";
    extraConfig = {
      modi = "window,run,drun";
      icon-theme = "Papirus";
      show-icons = true;
      display-drun = "";
      display-window = "";
      drun-display-format = "{icon} {name}";
    };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          bg = mkLiteral "#050505";
          bg-alt = mkLiteral "#191919";
          fg = mkLiteral "#FFFFFF";
          fg-alt = mkLiteral"#787c99";
          background-color = mkLiteral "@bg";
          border = 0;
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "window" = {
          width = mkLiteral "40%";
        };

        "element" = {
          padding = 12;
          text-color = mkLiteral "@fg-alt";
        };

        "element selected" = {
          text-color = mkLiteral "@fg";
        };

        "element-text" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
        };

        "element-icon" = {
          size = 38;
        };

        "entry" = {
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@fg";
          padding = 14;
          placeholder = "Search...";
        };

        "inputbar" = {
          children = map mkLiteral [ "prompt" "entry" ];
        };

        "listview" = {
          columns = 2;
          lines = 6;
          background-color = mkLiteral "@bg";
        };

        "prompt" = {
          enabled = true;
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@fg";
          padding = mkLiteral "14 10 0 14";
        };
      };
  };
}
