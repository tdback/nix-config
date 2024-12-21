{ ... }:
let
  port = 51820;
in
{
  networking = {
    firewall.allowedUDPPorts = [ port ];

    wg-quick.interfaces.wg0 = {
      autostart = true;
      listenPort = port;
      configFile = "/etc/wireguard/wg0.conf";
    };
  };
}
