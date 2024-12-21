{ lib, ... }:
let
  directory = "/opt/freshrss";
  port = "8888";
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0755 share share - -") (lib.lists.singleton directory);

  virtualisation.oci-containers.containers.freshrss = {
    image = "freshrss/freshrss:latest";
    autoStart = true;
    ports = [
      "${port}:80"
    ];
    volumes = [
      "${directory}/data:/var/www/FreshRSS/data"
      "${directory}/extensions:/var/www/FreshRSS/extensions"
    ];
    environment = {
      TZ = "America/Detroit";
      CRON_MIN = "*/20";
    };
  };

  services.caddy.virtualHosts."fresh.brownbread.net".extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:${port}
  '';
}
