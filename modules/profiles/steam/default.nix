# modules/profiles/steam/default.nix
#
# For the occasional gaming session with friends.

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
