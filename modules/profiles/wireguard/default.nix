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
