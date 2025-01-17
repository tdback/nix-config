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
    hostName = "frigg";
    hostId = "7a7d723a"; # Required for ZFS support.
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

  time.timeZone = "America/Detroit";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    zfs.extraPools = [ "tank" ];
  };

  services.zquota = {
    enable = true;
    quotas = {
      "tank/sftpgo" = 512;
    };
  };

  services.sftpgo.dataDir = "/tank/sftpgo";

  programs.motd = {
    enable = true;
    networkInterfaces = [ "enp59s0" ];
    servicesToCheck = [
      "caddy"
      "sftpgo"
      "zfs-zed"
    ];
  };
}
