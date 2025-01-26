{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f3bedccb-3f2b-49ae-9be4-5ec9fe683027";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/78C3-E7F8";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
