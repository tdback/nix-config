{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e336b96d-b3b4-4098-a0ca-9001fd381f88";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F804-40A9";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
