{
  config,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];
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
}
