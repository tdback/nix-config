{ lib, ... }:
let
  ports = lib.lists.singleton 2222;
in
{
  services.openssh = {
    enable = lib.mkDefault true;
    ports = ports;
    openFirewall = true;
    startWhenNeeded = true;
    settings = {
      AllowUsers = [ "tdback" ];
      PermitRootLogin = "no";
      PasswordAuthentication = lib.mkDefault false;
    };
  };
}
