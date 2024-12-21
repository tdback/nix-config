{ config, ... }:
{
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
