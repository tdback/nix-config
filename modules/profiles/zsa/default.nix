# modules/profiles/zsa/default.nix
#
# To avoid wrist pain and mitigate the chances of RSI, I use a split keyboard at
# home. This provides the udev rules and a utility for flashing custom firmware.

{
  pkgs,
  ...
}:
{
  hardware.keyboard.zsa.enable = true;
  environment.systemPackages = with pkgs; [ keymapp ];
}
