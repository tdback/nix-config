{ pkgs, ... }:
let
  port = 8888;
in
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    environmentFile = "/var/lib/searx/env";
    settings = {
      general = {
        debug = false;
        instance_name = "searx";
      };
      search = {
        safe_search = 1;
        autocomplete = "duckduckgo";
        autocomplete_min = 4;
        default_lang = "en-US";
      };
      server = {
        port = port;
        bind_address = "0.0.0.0";
        secret_key = "@SEARX_SECRET_KEY@";
        public_instance = false;
        image_proxy = true;
      };
      ui.static_use_hash = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
