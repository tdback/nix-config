{
  inputs,
  ...
}:
{
  system.stateVersion = "24.11";

  imports = [
    ./filesystems
    ./modules
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda2";
    efiSupport = true;
  };
  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"
      "virtio_scsi"
      "sr_mod"
    ];
    kernelModules = [ "dm-snapshot" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
      headless = true;
    };
  };

  time.timeZone = "America/Detroit";
  networking = {
    hostName = "loki";
    networkmanager.enable = true;
  };
}
