# modules/profiles/podman/default.nix
#
# Podman is my preferred OCI container backend. It has the added bonus of
# supporting building and starting containers via systemd.

{
  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
