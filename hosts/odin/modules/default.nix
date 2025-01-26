{
  modules = {
    containers.watchtower.enable = true;
    containers.pinchflat = {
      enable = true;
      mediaDir = "/tank/media/yt";
    };
    containers.freshrss = {
      enable = true;
      url = "fresh.brownbread.net";
    };
    containers.lubelogger = {
      enable = true;
      url = "garage.brownbread.net";
    };
    containers.vaultwarden = {
      enable = true;
      url = "steel-mountain.brownbread.net";
    };
    containers.jellyfin = {
      enable = true;
      url = "buttered.brownbread.net";
      mediaDir = "/tank/media";
    };
    services.immich = {
      enable = true;
      url = "photographs.brownbread.net";
      mediaDir = "/tank/immich";
    };
    scripts.motd = {
      enable = true;
      networkInterfaces = [ "eno1" ];
      servicesToCheck = [
        "caddy"
        "immich-machine-learning"
        "immich-server"
        "postgresql"
        "redis-immich"
        "zfs-zed"
      ];
    };
    scripts.zquota = {
      enable = true;
      quotas = {
        "tank/backups" = 512;
        "tank/media" = 1536;
      };
    };
  };
}
