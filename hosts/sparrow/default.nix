{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  system.stateVersion = "24.05";

  imports = [ ./filesystems ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];
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
    hostName = "sparrow";
    networkmanager.enable = true;
  };

  # Since I don't always use my split keyboard, remap CAPS to left CTRL.
  console.useXkbConfig = true;
  services = {
    xserver.xkb.options = "ctrl:swapcaps";
    libinput.enable = true;
  };

  environment.systemPackages = with pkgs; [
    acpi
    unstable.qbittorrent
  ];
}
