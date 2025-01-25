{
  config,
  lib,
  ...
}:
let
  sshPort = 2222;
  wheelUsers =
    with config.users;
    with builtins;
    filter (u: elem "wheel" users.${u}.extraGroups) (attrNames users);
in
{
  services.openssh = {
    enable = lib.mkDefault true;
    openFirewall = true;
    startWhenNeeded = true;
    ports = [ sshPort ];
    settings = {
      AllowUsers = wheelUsers;
      PermitRootLogin = "no";
      PasswordAuthentication = lib.mkDefault false;
    };
  };
}
