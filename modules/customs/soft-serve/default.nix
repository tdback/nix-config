{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.soft-serve;
  cfgFile = format.generate "config.yaml" cfg.settings;
  format = pkgs.formats.yaml { };
  dataDir = cfg.dataDir;
  docUrl = "https://github.com/charmbracelet/soft-serve";
in
{
  disabledModules = [ "services/misc/soft-serve.nix" ];

  options = {
    services.soft-serve = {
      enable = mkEnableOption "soft-serve";
      package = mkPackageOption pkgs "soft-serve" { };
      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/soft-serve";
        description = ''
          The directory where soft-serve stores its data files.
        '';
      };
      settings = mkOption {
        type = format.type;
        default = { };
        description = ''
          soft-serve server configurations stored under your data directory.
          See <${docUrl}>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "L+ ${dataDir}/config.yaml - - - - ${cfgFile}"
    ];

    systemd.services.soft-serve = {
      description = "Soft Serve git server";
      documentation = [ docUrl ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.SOFT_SERVE_DATA_PATH = dataDir;
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
        ExecStart = "${getExe cfg.package} serve";
        WorkingDirectory = dataDir;
      };
    };

    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
