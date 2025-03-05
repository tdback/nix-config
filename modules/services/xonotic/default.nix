{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.xonotic;
  setMutators = mutators: mapAttrs' (m: v: nameValuePair ("g_" + m) (if v then 1 else 0)) mutators;
in
{
  options.modules.services.xonotic = {
    enable = mkEnableOption "xonotic";
    package = mkPackageOption pkgs "xonotic-dedicated" { };
    port = mkOption {
      default = 26000;
      type = types.int;
    };
    hostname = mkOption {
      default = "Xonotic Server";
      type = types.str;
    };
    public = mkOption {
      default = true;
      type = types.bool;
    };
    motd = mkOption {
      default = "";
      type = types.str;
    };
    maxplayers = mkOption {
      default = 8;
      type = types.int;
    };
    minplayers = mkOption {
      default = 4;
      type = types.int;
    };
    g_mutators = mkOption {
      default = { };
      type = types.attrsOf types.bool;
      description = "Enable server mutators. Refer to upstream configuration.";
    };
  };

  config = mkIf cfg.enable {
    services.xonotic = {
      enable = true;
      package = cfg.package;
      openFirewall = true;
      settings = {
        net_address = "0.0.0.0";
        port = cfg.port;
        hostname = cfg.hostname;
        sv_public = if cfg.public then 1 else 0;
        sv_motd = cfg.motd;
        maxplayers = cfg.maxplayers;
        minplayers = cfg.minplayers;
        minplayers_per_team = cfg.minplayers / 2;
      } // (setMutators cfg.g_mutators);
    };
  };
}
