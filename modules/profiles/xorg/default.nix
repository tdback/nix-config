# modules/profiles/xorg/default.nix
#
# Sure X11 is "old", but xmonad doesn't yet have xorg support. I've got my eyes
# on https://github.com/YaLTeR/niri though.

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
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs.xorg; [
    libX11
    xset
  ];

  fonts.packages = with pkgs; [
    unstable.aporetic
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
