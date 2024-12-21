{ lib, ... }:
let
  directory = "/opt/vaultwarden";
  domain = "steel-mountain.brownbread.net";
  port = "11001";
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0755 share share - -") (lib.lists.singleton directory);

  virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:latest";
    autoStart = true;
    ports = [
      "${port}:80"
    ];
    volumes = [
      "${directory}/data:/data"
    ];
    environment = {
      DOMAIN = domain;
      WEBSOCKET_ENABLED = "true";
      SIGNUPS_ALLOWED = "false";
      SHOW_PASSWORD_HINT = "false";
    };
  };

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:${port} {
      header_up X-Real-IP {remote_host}
    }
  '';
}
