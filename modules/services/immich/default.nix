{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.immich;
in
{
  options.modules.services.immich = {
    enable = mkEnableOption "immich";
    port = mkOption {
      default = 2283;
      type = types.int;
    };
    url = mkOption {
      default = null;
      type = types.str;
    };
    mediaDir = mkOption {
      default = "/var/lib/immich";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf (cfg.url != null) [
      80
      443
    ];

    services.caddy = mkIf (cfg.url != null) {
      enable = true;
      virtualHosts = {
        "photographs.brownbread.net".extraConfig = ''
          encode zstd gzip
          reverse_proxy http://localhost:${builtins.toString cfg.port}
        '';
      };
    };

    services.immich = {
      enable = true;
      package = pkgs.immich;
      host = "localhost";
      port = cfg.port;
      mediaLocation = cfg.mediaDir;
      environment = {
        IMMICH_LOG_LEVEL = "log";
      };
    };
  };
}
