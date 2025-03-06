{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5ac7df5a-5908-4b6a-b982-88c34775205a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/ED26-4D10";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
