{
  config,
  ...
}:
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
    services.llm = {
      enable = true;
      port = 11111;
      networkRange = "10.44.0.0/16";
      nvidiaGpu = true;
      models = [
        "mistral"
        "llama3.2"
      ];
    };
    services.sftpgo = {
      enable = true;
      dataDir = "/tank/sftpgo";
      url = "${config.networking.hostName}.brownbread.net";
    };
    scripts.motd = {
      enable = true;
      networkInterfaces = [ "enp59s0" ];
      servicesToCheck = [
        "caddy"
        "ollama"
        "sftpgo"
        "zfs-zed"
      ];
    };
    scripts.zquota = {
      enable = true;
      quotas = {
        "tank/sftpgo" = 512;
      };
    };
  };
}
