{ ... }:
{
  virtualisation.oci-containers.containers.watchtower = {
    image = "containrrr/watchtower:latest";
    autoStart = true;
    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment = {
      WATCHTOWER_CLEANUP = "true";
      WATCHTOWER_SCHEDULE = "0 0 5 * * *";
    };
  };
}
