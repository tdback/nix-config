{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.sftpgo;
in
{
  options.modules.services.sftpgo = {
    enable = mkEnableOption "sftpgo";
    port = mkOption {
      default = 8080;
      type = types.int;
    };
    url = mkOption {
      default = null;
      type = types.str;
    };
    dataDir = mkOption {
      default = "/var/lib/sftpgo";
      type = types.str;
    };
  };

  config =
    let
      caddy = cfg.url != null;
    in
    mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = mkIf caddy [
        80
        443
      ];

      services.caddy = mkIf caddy {
        enable = true;
        virtualHosts = {
          ${cfg.url}.extraConfig = ''
            root * /web/client
            encode zstd gzip
            reverse_proxy http://localhost:${builtins.toString cfg.port}
          '';
        };
      };

      services.sftpgo = {
        enable = true;
        package = pkgs.sftpgo;
        dataDir = cfg.dataDir;
        settings = {
          httpd.bindings = lib.singleton {
            port = cfg.port;
            address = "0.0.0.0";
            enable_web_client = true;
            enable_web_admin = true;
          };
        };
      };
    };
}
