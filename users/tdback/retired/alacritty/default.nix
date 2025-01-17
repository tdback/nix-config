{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
    settings = {
      env.TERM = "xterm-256color";
      mouse.hide_when_typing = true;
      scrolling.history = 10000;
      window = {
        decorations = "None";
        opacity = 1.0;
        title = "Alacritty";
        padding.x = 4;
      };
      cursor.style.blinking = "Never";
      font = {
        size = 14.0;
        normal = {
          family = "Iosevka Comfy Motion Fixed";
          style = "Regular";
        };
        italic = {
          family = "Iosevka Comfy Motion Fixed";
          style = "Italic";
        };
        bold = {
          family = "Iosevka Comfy Motion Fixed";
          style = "Bold";
        };
        bold_italic = {
          family = "Iosevka Comfy Motion Fixed";
          style = "Bold Italic";
        };
      };
      # Tomorrow Night Bright colorscheme.
      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "#000000";
          foreground = "#eaeaea";
        };
        normal = {
          black = "#000000";
          red = "#d54e53";
          green = "#b9ca4a";
          yellow = "#e6c547";
          blue = "#7aa6da";
          magenta = "#c397d8";
          cyan = "#70c0ba";
          white = "#424242";
        };
        bright = {
          black = "#666666";
          red = "#ff3334";
          green = "#9ec400";
          yellow = "#e7c547";
          blue = "#7aa6da";
          magenta = "#b77ee0";
          cyan = "#54ced6";
          white = "#2a2a2a";
        };
      };
    };
  };
}
