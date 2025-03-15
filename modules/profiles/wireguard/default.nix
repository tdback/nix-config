# modules/profiles/wireguard/default.nix
#
# Although my current ISP doesn't plague me with CGNAT, I use IPv6rs with
# wireguard to host services from home without exposing ports on my router's
# firewall.

let
  listenPort = 51820;
in
{
  networking = {
    firewall.allowedUDPPorts = [ listenPort ];
    wg-quick.interfaces.wg0 = {
      inherit listenPort;
      autostart = true;
      configFile = "/etc/wireguard/wg0.conf";
    };
  };
}
