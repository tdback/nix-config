{ pkgs, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
