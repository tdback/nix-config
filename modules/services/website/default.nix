{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.services.website;
in
{
  options.modules.services.website = {
    enable = mkEnableOption "website";
    url = mkOption {
      type = types.str;
    };
    federating = mkOption {
      default = false;
      type = types.bool;
      description = "Federating a matrix server on this domain.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        ${cfg.url}.extraConfig =
          let
            synapseUrl = "synapse.${cfg.url}";
            synapseBaseUrl = "https://${synapseUrl}";
          in
          (
            if cfg.federating then
              ''
                handle /.well-known/matrix/server {
                  header Content-Type application/json
                  header Access-Control-Allow-Origin *
                  respond `{"m.server": "${synapseUrl}:443"}`
                }

                handle /.well-known/matrix/client {
                  header Content-Type application/json
                  header Access-Control-Allow-Origin *
                  respond `{"m.homeserver": {"base_url": "${synapseBaseUrl}"}}`
                }
              ''
            else
              ""
          )
          + ''
            root * /var/www/${cfg.url}/
            encode zstd gzip
            file_server
          '';
      };
    };
  };
}
