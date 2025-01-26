{
  config,
  lib,
  ...
}:
with lib;
let
  service = "lubelogger";
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
      default = 8889;
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
      image = "ghcr.io/hargata/lubelogger:latest";
      autoStart = true;
      ports = [ "${builtins.toString cfg.port}:8080" ];
      volumes = [
        "${cfg.configDir}/config:/App/config"
        "${cfg.configDir}/data:/App/data"
        "${cfg.configDir}/translations:/App/wwwroot/translations"
        "${cfg.configDir}/documents:/App/wwwroot/documents"
        "${cfg.configDir}/images:/App/wwwroot/images"
        "${cfg.configDir}/temp:/App/wwwroot/temp"
        "${cfg.configDir}/log:/App/log"
        "${cfg.configDir}/keys:/root/.aspnet/DataProtection-Keys"
      ];
      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        LUBELOGGER_ALLOWED_FILE_EXTENSIONS = "*";
      };
    };
  };
}
