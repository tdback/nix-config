{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.dns;
in
{
  options.modules.services.dns = {
    enable = mkEnableOption "dns";
    port = mkOption {
      default = 53;
      type = types.int;
    };
    subnet = mkOption {
      default = "192.168.0.0/24";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
    services.unbound = {
      enable = true;
      package = pkgs.unbound-with-systemd;
      enableRootTrustAnchor = true;
      resolveLocalQueries = true;
      settings.server = {
        interface = [ "0.0.0.0" ];
        port = cfg.port;
        access-control = [ "${cfg.subnet} allow" ];
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        edns-buffer-size = 1232;
        prefetch = true;
        hide-identity = true;
        hide-version = true;
      };
    };
  };
}
