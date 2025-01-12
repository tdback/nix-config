{ pkgs, ... }:
{
  services.unbound = {
    enable = true;
    package = pkgs.unbound-with-systemd;
    enableRootTrustAnchor = true;
    resolveLocalQueries = true;
    settings.server = {
      interface = [ "0.0.0.0" ];
      port = 53;
      access-control = [ "10.44.0.0/16 allow" ];
      harden-glue = true;
      harden-dnssec-stripped = true;
      use-caps-for-id = false;
      edns-buffer-size = 1232;
      prefetch = true;
      hide-identity = true;
      hide-version = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
