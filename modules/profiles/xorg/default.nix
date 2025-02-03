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
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
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
