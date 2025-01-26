{
  lib,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d296f7a3-68d2-406f-963d-8ec39ab0ea64";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B159-723B";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = lib.singleton {
    device = "/.swapfile";
  };
}
