{ config, ... }:
let
  fqdn = "synapse.${config.networking.domain}";
  baseUrl = "https://${fqdn}";
in
{
  networking.domain = "tdback.net";
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      ${config.networking.domain}.extraConfig = ''
        handle /.well-known/matrix/server {
          Content-Type application/json
          Access-Control-Allow-Origin *
          respond `{"m.server": "${fqdn}:443"}`
        }

        handle /.well-known/matrix/client {
          Content-Type application/json
          Access-Control-Allow-Origin *
          respond `{"m.homeserver": {"base_url": "${baseUrl}"}}`
        }

        root * /var/www/tdback.net/
        encode zstd gzip
        file_server
      '';
    };
  };
}
