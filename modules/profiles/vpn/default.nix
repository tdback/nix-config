# modules/profiles/vpn/default.nix
#
# Sometimes I'm on scary public networks, and I don't like other people
# sniffing my network packets.

{
  pkgs,
  ...
}:
{
  networking.nameservers = [ "9.9.9.9" ];
  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      dnsovertls = "true";
    };
  };
}
