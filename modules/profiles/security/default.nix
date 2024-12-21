{ lib, ... }:
{
  security = {
    polkit.enable = true;

    sudo.enable = lib.mkDefault false;
    doas = {
      enable = lib.mkDefault true;
      extraRules = [{
        groups = [ "wheel" ];
        keepEnv = true;
        persist = true;
      }];
    };
  };
}
