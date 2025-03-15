# modules/services/matrix/default.nix
#
# Secure, decentralized communication.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.matrix;
in
{
  options.modules.services.matrix = {
    enable = mkEnableOption "matrix";
    port = mkOption {
      default = 8008;
      type = types.int;
    };
    url = mkOption {
      type = types.str;
    };
    registrationSecret = mkOption {
      type = types.str;
      description = "Path to registration shared secret yaml file.";
    };
    coturnStaticAuth = mkOption {
      type = types.str;
      description = "Path to static auth secret file.";
    };
  };

  config = mkIf cfg.enable {
    age.secrets = {
      registrationSecret = {
        file = cfg.registrationSecret;
        owner = "matrix-synapse";
      };
      coturnStaticAuth = {
        file = cfg.coturnStaticAuth;
        owner = "turnserver";
      };
    };

    networking.firewall =
      let
        coturnPorts = [
          3478
          5349
        ];
        range =
          with config.services.coturn;
          lib.singleton {
            from = min-port;
            to = max-port;
          };
      in
      {
        allowedUDPPortRanges = range;
        allowedUDPPorts = coturnPorts;
        allowedTCPPortRanges = [ ];
        allowedTCPPorts = coturnPorts ++ [
          80
          443
        ];
      };

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
      initialScript = pkgs.writeText "synapse-init.sql" ''
        CREATE ROLE "matrix-synapse";
        CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
      '';
    };

    services.coturn = {
      enable = true;
      use-auth-secret = true;
      static-auth-secret-file = config.age.secrets.coturnStaticAuth.path;
      realm = "turn.${cfg.url}";
      no-tcp-relay = true;
      no-tls = true;
      no-dtls = true;
      extraConfig = ''
        user-quota=12
        total-quota=1200
        no-multicast-peers
        denied-peer-ip=0.0.0.0-0.255.255.255
        denied-peer-ip=10.0.0.0-10.255.255.255
        denied-peer-ip=100.64.0.0-100.127.255.255
        denied-peer-ip=127.0.0.0-127.255.255.255
        denied-peer-ip=169.254.0.0-169.254.255.255
        denied-peer-ip=172.16.0.0-172.31.255.255
        denied-peer-ip=192.0.0.0-192.0.0.255
        denied-peer-ip=192.0.2.0-192.0.2.255
        denied-peer-ip=192.88.99.0-192.88.99.255
        denied-peer-ip=192.168.0.0-192.168.255.255
        denied-peer-ip=198.18.0.0-198.19.255.255
        denied-peer-ip=198.51.100.0-198.51.100.255
        denied-peer-ip=203.0.113.0-203.0.113.255
        denied-peer-ip=240.0.0.0-255.255.255.255
      '';
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "synapse.${cfg.url}".extraConfig =
          let
            localhost = "http://localhost:${builtins.toString cfg.port}";
          in
          ''
            reverse_proxy /_matrix/* ${localhost}
            reverse_proxy /_synapse/client/* ${localhost}
          '';
      };
    };

    services.matrix-synapse = {
      enable = true;
      extraConfigFiles = [ config.age.secrets.registrationSecret.path ];
      settings = {
        server_name = cfg.url;
        public_baseurl = "https://synapse.${cfg.url}";
        listeners = lib.singleton {
          port = cfg.port;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = lib.singleton {
            names = [
              "client"
              "federation"
            ];
            compress = true;
          };
        };
        turn_uris = with config.services.coturn; [
          "turn:${realm}?transport=udp"
          "turn:${realm}?transport=tcp"
        ];
      };
    };
  };
}
