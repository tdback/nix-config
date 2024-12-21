{ inputs, config, lib, pkgs, ... }:
let
  domain = "git.tdback.net";
  port = 3000;
in
{
  services.forgejo = {
    enable = true;
    package = pkgs.unstable.forgejo;
    stateDir = "/tank/forgejo";
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = domain;
        ROOT_URL = "https://${domain}/";
        HTTP_PORT = port;
      };
      service.DISABLE_REGISTRATION = true;
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "https://${domain}";
      };
    };
  };

  age.secrets.forgejoAdminPass = {
    file = "${inputs.self}/secrets/forgejoAdminPass.age";
    mode = "770";
    owner = "forgejo";
    group = "forgejo";
  };

  systemd.services.forgejo.preStart =
    let
      adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
      password = config.age.secrets.forgejoAdminPass.path;
      user = "tdback";
      email = "tyler@tdback.net";
    in ''
      ${adminCmd} create --admin --email ${email} --username ${user} --password "$(tr -d '\n' < ${password})" || true
    '';

  services.openssh.settings.AllowUsers = [ "forgejo" ];

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    encode zstd gzip
    reverse_proxy http://localhost:${builtins.toString port}
  '';

  age.secrets.forgejoRunnerToken.file = "${inputs.self}/secrets/forgejoRunnerToken.age";
  services.gitea-actions-runner = {
    package = pkgs.unstable.forgejo-runner;
    instances.default = {
      enable = true;
      name = "monolith";
      url = "https://${domain}";
      tokenFile = config.age.secrets.forgejoRunnerToken.path;
      labels = [
        "ubuntu-latest:docker://node:20-bookworm"
        "ubuntu-22.04:docker://node:20-bookworm"
      ];
    };
  };
}
