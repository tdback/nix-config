{ config, pkgs, ... }:
{
  services.sftpgo = {
    enable = true;
    package = pkgs.sftpgo;
    settings = {
      httpd.bindings = [{
        port = 8080;
        address = "0.0.0.0";
        enable_web_client = true;
        enable_web_admin = true;
      }];
    };
  };

  services.caddy.virtualHosts."${config.networking.hostName}.brownbread.net".extraConfig = ''
    root * /web/client
    encode zstd gzip
    reverse_proxy http://localhost:8080
  '';
}
