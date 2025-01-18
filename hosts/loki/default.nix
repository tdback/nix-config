{ inputs, ... }:
{
  system.stateVersion = "24.11";

  imports = [ ./hardware.nix ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
      headless = true;
    };
  };

  networking = {
    hostName = "loki";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Helsinki";

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda2";
    efiSupport = true;
  };

  programs.motd = {
    enable = true;
    networkInterfaces = [ "enp1s0" ];
    servicesToCheck = [ ];
  };
}
