# modules/services/ssh/default.nix
#
# Configuration for secure remote access. I mainly use `mosh' for remoting into
# servers, as it provides a smoother experience for boxes hosted halfway around
# the world.

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

  # SSH over UDP!
  programs.mosh.enable = true;
}
