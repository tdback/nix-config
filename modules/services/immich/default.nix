{ pkgs, ... }:
{
  services.immich = {
    enable = true;
    package = pkgs.immich;
    host = "localhost";
    port = 2283;
    mediaLocation = "/lagoon/media/immich";
    environment = {
      IMMICH_LOG_LEVEL = "log";
    };
  };

  services.caddy.virtualHosts."photographs.brownbread.net".extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:2283
  '';
}
