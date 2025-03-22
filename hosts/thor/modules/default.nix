{
  pkgs,
  ...
}:
{
  modules = {
    services.fediverse = {
      enable = true;
      package = pkgs.unstable.gotosocial;
      url = "social.tdback.net";
      landingPageUser = "tdback";
    };
    services.website = {
      enable = true;
      url = "tdback.net";
      federating = true;
    };
    scripts.motd = {
      enable = true;
      networkInterfaces = [ "eno1" ];
      servicesToCheck = [
        "caddy"
        "gotosocial"
      ];
    };
  };
}
