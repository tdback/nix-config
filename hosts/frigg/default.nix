{
  inputs,
  lib,
  ...
}:
{
  system.stateVersion = "24.05";

  imports = [
    ./filesystems
    ./modules
  ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
    "sdhci_pci"
    "usb_storage"
    "xhci_pci"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.zfs.extraPools = [ "tank" ];

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
    hostName = "frigg";
    # A host ID is required when enabling ZFS.
    hostId = "7a7d723a";
    nameservers = [ "10.44.0.1" ];
    defaultGateway.address = "10.44.0.1";
    interfaces.enp59s0 = {
      useDHCP = false;
      ipv4.addresses = lib.singleton {
        address = "10.44.4.103";
        prefixLength = 16;
      };
    };
  };
}
