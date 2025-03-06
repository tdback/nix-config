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
    device = "nodev";
  };
  boot.initrd = {
    availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
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
    hostName = "sol";
    networkmanager.enable = true;
  };
}
