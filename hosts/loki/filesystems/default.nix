{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a3a9fc5f-8809-4db0-b0f3-08e58cb79716";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F4CB-1F7D";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
