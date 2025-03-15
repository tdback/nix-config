# modules/containers/watchtower/default.nix
#
# I don't want to login and manually update my containers.

{
  config,
  lib,
  ...
}:
with lib;
let
  service = "watchtower";
  cfg = config.modules.containers.${service};
in
{
  options.modules.containers.${service} = {
    enable = mkEnableOption service;
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.${service} = {
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
  };
}
