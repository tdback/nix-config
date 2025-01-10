{ lib, ... }:
let
  inherit (lib.lists) singleton;
  directory = "/opt/lubelogger";
  port = "8889";
in
{
  systemd.tmpfiles.rules = builtins.map (x: "d ${x} 0755 share share - -") (singleton directory);

  virtualisation.oci-containers.containers.lubelogger = {
    image = "ghcr.io/hargata/lubelogger:latest";
    autoStart = true;
    ports = singleton "${port}:8080";
    volumes = [
      "${directory}/config:/App/config"
      "${directory}/data:/App/data"
      "${directory}/translations:/App/wwwroot/translations"
      "${directory}/documents:/App/wwwroot/documents"
      "${directory}/images:/App/wwwroot/images"
      "${directory}/temp:/App/wwwroot/temp"
      "${directory}/log:/App/log"
      "${directory}/keys:/root/.aspnet/DataProtection-Keys"
    ];
    environment = {
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      LUBELOGGER_ALLOWED_FILE_EXTENSIONS = "*";
    };
  };

  services.caddy.virtualHosts."garage.brownbread.net".extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:${port}
  '';
}
