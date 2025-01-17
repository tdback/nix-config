{ inputs, pkgs, ... }:
{
  system.stateVersion = "24.05";

  imports = [ ./hardware.nix ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
      headless = false;
    };
  };

  networking = {
    hostName = "sparrow";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Detroit";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "riscv64-linux"
    ];
  };

  # Since I don't always carry my split keyboard, remap CAPS to left CTRL.
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
