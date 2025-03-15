# modules/profiles/zfs/default.nix
#
# Enabling the ZFS kernel module and configuring notifications for scrub
# results, which are run monthly.

{
  lib,
  pkgs,
  ...
}:
{
  boot = {
    zfs.forceImportRoot = false;
    supportedFilesystems.zfs = lib.mkForce true;
  };

  services.zfs = {
    autoScrub.enable = true;
    zed = {
      enableMail = false;
      settings = {
        ZED_DEBUG_LOG = "/tmp/zed.debug.log";
        ZED_EMAIL_ADDR = [ "root" ];
        ZED_EMAIL_PROG = "/run/current-system/sw/bin/pushover";
        ZED_EMAIL_OPTS = "-t '@SUBJECT@'";
        ZED_NOTIFY_INTERVAL_SECS = 3600;
        ZED_NOTIFY_VERBOSE = true;
        ZED_USE_ENCLOSURE_LEDS = true;
        ZED_SCRUB_AFTER_RESILVER = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [ zfs ];
}
