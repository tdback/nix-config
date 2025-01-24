{ pkgs, ... }:
{
  services.mpd = {
    enable = true;
    package = pkgs.unstable.mpd;
    musicDirectory = "~/media/music";
    extraConfig = ''
      log_file               "syslog"
      max_output_buffer_size "16384"
      restore_paused         "yes"
      auto_update            "yes"
      audio_output {
          type        "pulse"
          name        "pulseaudio"
      }
      audio_output {
          type        "fifo"
          name        "Visualizer feed"
          path        "/tmp/mpd.fifo"
          format      "44100:16:2"
      }
    '';
  };

  # Add mpc for controlling mpd.
  home.packages = with pkgs.unstable; [ mpc-cli ];
}
