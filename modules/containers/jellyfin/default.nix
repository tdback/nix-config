{ lib, ... }:
let
  directory = "/opt/jellyfin";
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0755 share share - -") (lib.lists.singleton directory);

  virtualisation.oci-containers.containers.jellyfin = {
    image = "jellyfin/jellyfin:latest";
    autoStart = true;
    user = "994:994";
    ports = [
      "8096:8096/tcp"
    ];
    volumes = [
      "${directory}/config:/config"
      "${directory}/cache:/cache"
      "/tank/media:/media"
    ];
  };

  services.caddy.virtualHosts."buttered.brownbread.net".extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:8096
  '';
}
