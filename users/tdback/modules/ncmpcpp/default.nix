{
  pkgs,
  ...
}:
{
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.unstable.ncmpcpp.override { visualizerSupport = true; };
    mpdMusicDir = "~/media/music";
    settings = {
      ncmpcpp_directory = "~/.config/ncmpcpp";
      lyrics_directory = "~/.local/share/lyrics";
      song_list_format = "{%a - }{%t}|{$8%f$9}$R{$3%l$9}";
      song_status_format = "{{%a{ \"%b\"{ (%y)}} - }{%t}}|{%f}";
      song_library_format = "{%n - }{%t}|{%f}";
      alternative_header_first_line_format = "$b$1$aqqu$/a$9 {%t}|{%f} $1$atqq$/a$9$/b";
      alternative_header_second_line_format = "{{$4$b%a$/b$9}{ - $7%b$9}{ ($4%y$9)}}|{%D}";
      current_item_prefix = "$(yellow)$r";
      current_item_suffix = "$/r$(end)";
      current_item_inactive_column_prefix = "$(white)$r";
      current_item_inactive_column_suffix = "$/r$(end)";
      now_playing_prefix = "$b";
      now_playing_suffix = "$/b";
      browser_playlist_prefix = "$2playlist$9 ";
      selected_item_prefix = "$6";
      selected_item_suffix = "$9";
      modified_item_prefix = "$3> $9";
      song_window_title_format = "{%a - }{%t}|{%f}";
      browser_sort_mode = "type";
      browser_sort_format = "{%a - }{%t}|{%f} {%l}";
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer feed";
      visualizer_in_stereo = true;
      visualizer_type = "spectrum";
      visualizer_look = "●▮";
      visualizer_color = "blue, cyan, green, yellow, magenta, red";
      visualizer_spectrum_smooth_look = true;
    };

    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "h";
        command = [
          "previous_column"
          "jump_to_parent_directory"
        ];
      }
      {
        key = "l";
        command = [
          "next_column"
          "enter_directory"
          "run_action"
          "play_item"
        ];
      }
      {
        key = "u";
        command = "page_up";
      }
      {
        key = "d";
        command = "page_down";
      }
      {
        key = "ctrl-u";
        command = "page_up";
      }
      {
        key = "ctrl-d";
        command = "page_down";
      }
      {
        key = "g";
        command = "move_home";
      }
      {
        key = "G";
        command = "move_end";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
      {
        key = "J";
        command = "move_sort_order_down";
      }
      {
        key = "K";
        command = "move_sort_order_up";
      }
      {
        key = "f";
        command = [
          "show_browser"
          "change_browse_mode"
        ];
      }
      {
        key = "s";
        command = [
          "reset_search_engine"
          "show_search_engine"
        ];
      }
      {
        key = "m";
        command = "toggle_media_library_columns_mode";
      }
      {
        key = "x";
        command = "delete_playlist_items";
      }
      {
        key = "U";
        command = "update_database";
      }
      {
        key = "P";
        command = "show_playlist";
      }
      {
        key = "t";
        command = "show_tag_editor";
      }
      {
        key = "v";
        command = "show_visualizer";
      }
      {
        key = ".";
        command = "show_lyrics";
      }
      {
        key = "+";
        command = "show_clock";
      }
      {
        key = "=";
        command = "volume_up";
      }
    ];
  };
}
