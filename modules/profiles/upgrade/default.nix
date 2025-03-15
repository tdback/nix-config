{
  inputs,
  config,
  ...
}:
{
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "Sat *-*-* 06:00:00";
    randomizedDelaySec = "45min";
    allowReboot = true;
  };

  systemd.services."server-monitor" =
    let
      dependencies = [ "network-online.target" ];
    in
    {
      wantedBy = [ "multi-user.target" ];
      wants = dependencies;
      after = dependencies;
      serviceConfig.Type = "oneshot";
      script = ''
        ACTION="restarted"

        # If a system has been up for *at least* 90 seconds, make the assumption
        # that the system's configuration was rebuilt and activated.
        if [ "$(cat /proc/uptime | cut -f1 -d.)" -gt 90 ]; then
          ACTION="activated a new configuration"
        fi

        /run/current-system/sw/bin/pushover -t "${config.networking.hostName}" \
          "Server $ACTION on $(date '+%a, %b %d at %T %p %Z')."
      '';
    };
}
