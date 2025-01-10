{ lib, ... }:
let
  inherit (lib.lists) singleton;
  directory = "/opt/pinchflat";
in
{
  systemd.tmpfiles.rules = builtins.map (x: "d ${x} 0755 share share - -") (singleton directory);

  virtualisation.oci-containers.containers.pinchflat = {
    image = "keglin/pinchflat:latest";
    autoStart = true;
    ports = singleton "8945:8945";
    volumes = [
      "${directory}:/config"
      "/tank/media/yt:/downloads"
    ];
    environment.TZ = "America/Detroit";
  };
}
