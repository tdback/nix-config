{
  inputs,
  lib,
  pkgs,
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
    cpu.amd.updateMicrocode = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "ehci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];

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
    hostName = "thor";
    nameservers = [ "10.44.0.1" ];
    defaultGateway.address = "10.44.0.1";
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = lib.singleton {
        address = "10.44.4.102";
        prefixLength = 16;
      };
    };
  };
}
