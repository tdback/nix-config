{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3e333010-7dae-47cf-9288-85d58ddda699";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8430-1FF8";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
