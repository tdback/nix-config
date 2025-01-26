{
  config,
  lib,
  ...
}:
with lib;
let
  service = "pinchflat";
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
      default = 8945;
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

    systemd.tmpfiles.rules = builtins.map (f: "d ${f} 0755 ${cfg.user} ${cfg.group} - -") [
      cfg.configDir
    ];

    virtualisation.oci-containers.containers.${service} = {
      image = "keglin/pinchflat:latest";
      autoStart = true;
      ports = [ "${builtins.toString cfg.port}:${builtins.toString cfg.port}" ];
      volumes = [
        "${cfg.configDir}:/config"
        "${cfg.mediaDir}:/downloads"
      ];
      environment.TZ = "America/Detroit";
    };
  };
}
