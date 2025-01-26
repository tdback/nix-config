{
  config,
  lib,
  ...
}:
with lib;
let
  service = "jellyfin";
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
      default = 8096;
      type = types.int;
    };
    url = mkOption {
      default = null;
      type = types.str;
    };
    mediaDir = mkOption {
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

    virtualisation.oci-containers.containers.${service} =
      with config.users;
      with builtins;
      let
        uid = toString users.${cfg.user}.uid;
        gid = toString groups.${cfg.group}.gid;
        port = toString cfg.port;
      in
      {
        image = "${service}/${service}:latest";
        autoStart = true;
        user = "${uid}:${gid}";
        ports = [ "${port}:${port}/tcp" ];
        volumes = [
          "${cfg.configDir}/config:/config"
          "${cfg.configDir}/cache:/cache"
          "${cfg.mediaDir}:/media"
        ];
      };
  };
}
