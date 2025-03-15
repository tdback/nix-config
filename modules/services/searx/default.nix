# modules/services/searx/default.nix
#
# A metasearch engine and results aggregator.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.searx;
in
{
  options.modules.services.searx = {
    enable = mkEnableOption "searx";
    port = mkOption {
      default = 8888;
      type = types.int;
    };
    environmentFile = mkOption {
      default = "/var/lib/searx/env";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services.searx = {
      enable = true;
      package = pkgs.searxng;
      environmentFile = cfg.environmentFile;
      settings = {
        general = {
          debug = false;
          instance_name = "searx";
        };
        server = {
          port = cfg.port;
          bind_address = "0.0.0.0";
          secret_key = "@SEARX_SECRET_KEY@";
          public_instance = false;
          image_proxy = true;
        };
        search = {
          safe_search = 1;
          autocomplete = "duckduckgo";
          autocomplete_min = 4;
          default_lang = "en-US";
        };
        ui.static_use_hash = true;
      };
    };
  };
}
