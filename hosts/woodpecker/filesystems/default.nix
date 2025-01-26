{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/90ec7fc1-192e-4bb5-9bb5-5e2776435f8d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3A26-C3FB";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/cd7e081e-cd0b-4dc5-b41c-8dda26437a78";
    fsType = "ext4";
  };

  swapDevices = [ ];
}
