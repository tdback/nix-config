{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  fqdn = "synapse.${config.networking.domain}";
  baseUrl = "https://${fqdn}";
in
{
  age.secrets = {
    coturnStaticAuth = {
      file = "${inputs.self}/secrets/coturnStaticAuth.age";
      owner = "turnserver";
    };
    synapseYaml = {
      file = "${inputs.self}/secrets/synapseYaml.age";
      owner = "matrix-synapse";
    };
  };

  networking.domain = "tdback.net";
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
    realm = "turn.${config.networking.domain}";
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
      ${fqdn}.extraConfig = ''
        reverse_proxy /_matrix/* localhost:8008
        reverse_proxy /_synapse/client/* localhost:8008
      '';
    };
  };

  services.matrix-synapse = {
    enable = true;
    extraConfigFiles = [ config.age.secrets.synapseYaml.path ];
    settings = {
      server_name = config.networking.domain;
      public_baseurl = baseUrl;
      listeners = lib.singleton {
        port = 8008;
        bind_address = [ "::1" ];
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
        "turn:${realm}:3487?transport=udp"
        "turn:${realm}:3487?transport=tcp"
      ];
    };
  };
}
