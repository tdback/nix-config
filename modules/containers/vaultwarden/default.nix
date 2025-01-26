{
  config,
  lib,
  ...
}:
with lib;
let
  service = "vaultwarden";
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
      default = 11001;
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
          reverse_proxy http://localhost:${builtins.toString cfg.port} {
            header_up X-Real-IP {remote_host}
          }
        '';
      };
    };

    systemd.tmpfiles.rules = builtins.map (f: "d ${f} 0755 ${cfg.user} ${cfg.group} - -") [
      cfg.configDir
    ];

    virtualisation.oci-containers.containers.${service} = {
      image = "vaultwarden/server:latest";
      autoStart = true;
      ports = [ "${builtins.toString cfg.port}:80" ];
      volumes = [ "${cfg.configDir}/data:/data" ];
      environment = {
        DOMAIN = cfg.url;
        WEBSOCKET_ENABLED = "true";
        SIGNUPS_ALLOWED = "false";
        SHOW_PASSWORD_HINT = "false";
      };
    };
  };
}
