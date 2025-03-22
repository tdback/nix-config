# modules/services/fediverse/default.nix
#
# A portmanteau of "federation" and "universe". A lightweight instance for
# participating in decentralized social media.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.fediverse;
in
{
  options.modules.services.fediverse = {
    enable = mkEnableOption "fediverse";
    package = mkPackageOption pkgs "gotosocial" { };
    port = mkOption {
      default = 8080;
      type = types.int;
    };
    url = mkOption {
      type = types.str;
    };
    landingPageUser = mkOption {
      default = "";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        ${cfg.url}.extraConfig = ''
          encode zstd gzip
          reverse_proxy http://localhost:${builtins.toString cfg.port}
        '';
      };
    };

    services.gotosocial = {
      enable = true;
      package = cfg.package;
      settings = {
        application-name = "gotosocial";
        bind-address = "localhost";
        port = cfg.port;
        host = cfg.url;
        protocol = "https";
        db-type = "sqlite";
        db-address = "/var/lib/gotosocial/database.sqlite";
        storage-local-base-path = "/var/lib/gotosocial/storage";
        landing-page-user = cfg.landingPageUser;
      };
    };
  };
}
