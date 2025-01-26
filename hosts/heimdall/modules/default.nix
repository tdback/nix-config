{
  modules = {
    services.dns = {
      enable = true;
      subnet = "10.44.0.0/16";
    };
    services.searx.enable = true;
    scripts.motd = {
      enable = true;
      networkInterfaces = [ "eno1" ];
      servicesToCheck = [
        "searx"
        "unbound"
      ];
    };
  };
}
