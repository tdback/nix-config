{
  modules = {
    services.xonotic = {
      enable = true;
      hostname = "tdback's xonotic server";
      motd = "GLHF! Please report any issues to @tyler:tdback.net on matrix.";
      g_mutators.grappling_hook = true;
    };
    scripts.motd = {
      enable = true;
      networkInterfaces = [ "enp1s0" ];
      servicesToCheck = [ "xonotic" ];
    };
  };
}
