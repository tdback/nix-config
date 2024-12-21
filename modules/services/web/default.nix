{ ... }:
{
  services.caddy.virtualHosts = {
    "tdback.net".extraConfig = ''
      root * /var/www/tdback.net/
      encode zstd gzip
      file_server
    '';
  };
}
