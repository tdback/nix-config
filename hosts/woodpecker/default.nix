{ inputs, ... }:
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
    hostName = "woodpecker";
    nameservers = [ "10.44.0.1" ];
    defaultGateway.address = "10.44.0.1";
    interfaces.enp42s0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.44.4.50";
        prefixLength = 16;
      }];
    };
  };

  time.timeZone = "America/Detroit";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];
  };
}
