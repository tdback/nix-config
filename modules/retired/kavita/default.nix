{ ... }:
let
  directories = [
    "/opt/kavita"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0755 share share - -") directories;
  virtualisation.oci-containers.containers.kavita = {
    image = "jvmilazz0/kavita:latest";
    autoStart = true;
    ports = [
      "5000:5000"
    ];
    volumes = [
      "/opt/kavita/config:/kavita/config"
      "/tank/media/library/Books:/books"
    ];
    environment = {
      TZ = "America/Detroit";
    };
  };

  services.caddy.virtualHosts."library.tdback.net".extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:5000
  '';
}
