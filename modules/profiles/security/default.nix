{ lib, ... }:
{
  security = {
    polkit.enable = true;
    sudo = {
      enable = lib.mkDefault true;
      wheelNeedsPassword = lib.mkDefault false;
    };
  };
}
