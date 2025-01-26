{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d62103eb-e154-4b71-b813-54ca76815a80";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5972-1878";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
