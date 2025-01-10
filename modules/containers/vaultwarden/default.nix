{ lib, ... }:
let
  inherit (lib.lists) singleton;
  directory = singleton "/opt/vaultwarden";
  domain = "steel-mountain.brownbread.net";
  port = "11001";
in
{
  systemd.tmpfiles.rules = builtins.map (x: "d ${x} 0755 share share - -") (singleton directory);

  virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:latest";
    autoStart = true;
    ports = singleton "${port}:80";
    volumes = singleton "${directory}/data:/data";
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
