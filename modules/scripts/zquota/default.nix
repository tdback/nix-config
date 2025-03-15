# modules/scripts/zquota/default.nix
#
# Monitor ZFS dataset disk usage.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  script = "zquota";
  cfg = config.modules.scripts.${script};

  zquota =
    let
      bc = getExe pkgs.bc;
      zfs = getExe pkgs.zfs;
      hostname = config.networking.hostName;
    in
    pkgs.writeShellScriptBin script ''
      set -e

      if [ "$#" -ne 2 ]; then
        echo "failed to provide both a dataset and quota" >&2
        exit 1
      fi

      DATASET="$1"
      QUOTA="$2"

      if echo "$QUOTA" | grep -q '[^0-9.]'; then
        echo "failed to provide a valid quota" >&2
        exit 1
      fi

      USED=$(${zfs} list -Hpo used "$DATASET" 2>/dev/null) || {
        echo "failed to provide a valid dataset" >&2
        exit 1
      }

      USAGE=$(${bc} <<< "scale=2; $USED / 1024^3")

      DIFF=$(${bc} <<< "scale=2; $USAGE - $QUOTA")

      if [ 1 -eq $(${bc} <<< "$USAGE > $QUOTA") ]; then
        /run/current-system/sw/bin/pushover -t "${hostname} quota exceeded" \
          "dataset $DATASET on ${hostname} has exceeded quota by ''${DIFF}GB"
      fi
    '';
in
{
  options.modules.scripts.${script} = {
    enable = mkEnableOption script;
    quotas = mkOption {
      default = { };
      type = types.attrsOf types.int;
      description = "Attribute set of ZFS dataset and disk quota (in GB).";
    };
    dates = mkOption {
      default = "daily";
      type = types.str;
      description = ''
        How often quota checks are performed.

        This value must be a calendar event specified by
        {manpage}`systemd.time(7)`.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ zquota ];
    systemd.services.${script} = {
      description = "Perform and report scheduled quota checks on ZFS datasets.";
      serviceConfig.Type = "oneshot";
      script = strings.concatStringsSep "\n" (
        mapAttrsToList (
          dataset: quota: "/run/current-system/sw/bin/zquota ${dataset} ${builtins.toString quota}"
        ) cfg.quotas
      );
    };
    systemd.timers.${script} = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.dates;
        Persistent = true;
      };
    };
  };
}
