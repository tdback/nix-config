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

  systemd.services."reboot-alert" =
    let
      hostname = config.networking.hostName;
      dependencies = [ "network-online.target" ];
    in
    {
      wantedBy = [ "multi-user.target" ];
      wants = dependencies;
      after = dependencies;
      serviceConfig.Type = "oneshot";
      script = ''
        /run/current-system/sw/bin/pushover -t "${hostname} restarted" \
          "${hostname} has restarted on $(date '+%a, %b %d at %T %p %Z')."
      '';
    };
}
