{
  modules = {
    customs.cgit = {
      enable = true;
      scanPath = "/tank/git";
      url = "git.tdback.net";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzLpTEoej7P04KoNzokQ9IOnNZiKyi2+YQ8yU5WSKCb"
      ];
      settings = {
        root-title = "git.tdback.net";
        root-desc = "tdback's git repositories";
        enable-index-links = 1;
        enable-index-owner = 0;
        enable-commit-graph = 1;
        enable-log-filecount = 1;
        enable-log-linecount = 1;
        readme = ":README.md";
      };
    };
    services.dns = {
      enable = true;
      subnet = "10.44.0.0/16";
      verbosity = 2;
    };
    scripts.motd = {
      enable = true;
      networkInterfaces = [ "enp59s0" ];
      servicesToCheck = [
        "caddy"
        "unbound"
        "zfs-zed"
      ];
    };
  };
}
