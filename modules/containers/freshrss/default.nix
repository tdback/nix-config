# modules/containers/freshrss/default.nix
#
# An RSS reader and news aggregator.

{
  config,
  lib,
  ...
}:
with lib;
let
  service = "freshrss";
  cfg = config.modules.containers.${service};
in
{
  options.modules.containers.${service} = {
    enable = mkEnableOption service;
    user = mkOption {
      default = "share";
      type = types.str;
    };
    group = mkOption {
      default = "share";
      type = types.str;
    };
    port = mkOption {
      default = 8888;
      type = types.int;
    };
    url = mkOption {
      default = null;
      type = types.str;
    };
    configDir = mkOption {
      default = "/opt/${service}";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = { };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        ${cfg.url}.extraConfig = ''
          encode zstd gzip
          reverse_proxy http://localhost:${builtins.toString cfg.port}
        '';
      };
    };

    systemd.tmpfiles.rules = builtins.map (f: "d ${f} 0755 ${cfg.user} ${cfg.group} - -") [
      cfg.configDir
    ];

    virtualisation.oci-containers.containers.${service} = {
      image = "${service}/${service}:latest";
      autoStart = true;
      ports = [ "${builtins.toString cfg.port}:80" ];
      volumes = [
        "${cfg.configDir}/data:/var/www/FreshRSS/data"
        "${cfg.configDir}/extensions:/var/www/FreshRSS/extensions"
      ];
      environment = {
        TZ = "America/Detroit";
        CRON_MIN = "*/20";
      };
    };
  };
}
