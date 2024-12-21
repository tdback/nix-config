{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      displayManager.lightdm.enable = true;
      windowManager.bspwm.enable = true;
    };

    displayManager.autoLogin = {
      enable = true;
      user = "tdback";
    };
  };

  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs.xorg; [
    libX11
    xset
  ];

  fonts.packages = with pkgs; [
    dejavu_fonts
    dina-font
    iosevka-comfy.comfy-motion-fixed
    liberation_ttf
    noto-fonts
    noto-fonts-emoji
    ubuntu_font_family
  ];
}
