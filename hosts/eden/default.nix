{ lib, inputs, ... }:
{
  system.stateVersion = "24.05";

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
    hostName = "eden";
    hostId = "bd03847d"; # Required for ZFS support.
    nameservers = [ "10.44.0.1" ];
    defaultGateway.address = "10.44.0.1";
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.44.4.101";
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
    zfs.extraPools = [ "tank" ];
  };

  motd = {
    networkInterfaces = lib.lists.singleton "eno1";
    servicesToCheck = [
      "caddy"
      "immich-machine-learning"
      "immich-server"
      "postgresql"
      "redis-immich"
      "zfs-zed"
    ];
  };

  services.zquota = {
    enable = true;
    quotas = {
      "tank/backups" = 512;
      "tank/media" = 2048;
    };
  };
}
