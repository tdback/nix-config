{ ... }:
let
  directories = [
    "/opt/pinchflat"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0755 share share - -") directories;
  virtualisation.oci-containers.containers.pinchflat = {
    image = "keglin/pinchflat:latest";
    autoStart = true;
    ports = [
      "8945:8945"
    ];
    volumes = [
      "/opt/pinchflat:/config"
      "/tank/media/yt:/downloads"
    ];
    environment = {
      TZ = "America/Detroit";
    };
  };
}
