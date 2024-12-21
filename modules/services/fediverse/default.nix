{ pkgs, ... }:
let
  domain = "social.tdback.net";
  port = 8080;
in
{
  services.gotosocial = {
    enable = true;
    package = pkgs.unstable.gotosocial;
    settings = {
      application-name = "gotosocial";
      host = "${domain}";
      protocol = "https";
      bind-address = "localhost";
      port = port;
      db-type = "sqlite";
      db-address = "/var/lib/gotosocial/database.sqlite";
      storage-local-base-path = "/var/lib/gotosocial/storage";
    };
  };

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:${builtins.toString port}
  '';
}
