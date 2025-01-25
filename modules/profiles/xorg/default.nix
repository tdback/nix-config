{
  pkgs,
  ...
}:
{
  hardware.graphics.enable32Bit = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "tdback";
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    displayManager.lightdm.enable = true;
    windowManager.bspwm.enable = true;
  };

  environment.systemPackages = with pkgs.xorg; [
    libX11
    xset
  ];

  fonts.packages = with pkgs; [
    iosevka-comfy.comfy-motion-fixed
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
