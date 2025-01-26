{
  inputs,
  lib,
  ...
}:
{
  system.stateVersion = "24.05";

  imports = [ ./filesystems ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
      headless = false;
    };
  };

  time.timeZone = "America/Detroit";
  networking = {
    hostName = "woodpecker";
    nameservers = [ "10.44.0.1" ];
    defaultGateway.address = "10.44.0.1";
    interfaces.enp42s0 = {
      useDHCP = false;
      ipv4.addresses = lib.singleton {
        address = "10.44.4.50";
        prefixLength = 16;
      };
    };
  };
}
