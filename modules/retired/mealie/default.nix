{ config, pkgs, ... }:
let
  domain = "toasted.brownbread.net";
in
{
  services.mealie = {
    enable = true;
    package = pkgs.unstable.mealie;
    settings = {
      BASE_URL = domain;
      DB_ENGINE = "sqlite";
      ALLOW_SIGNUP = "false";
      SECURITY_MAX_LOGIN_ATTEMPTS = 3;
      TZ = "America/Detroit";
    };
  };

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:${builtins.toString config.services.mealie.port}
  '';
}
