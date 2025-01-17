{ pkgs, ... }:
{
  services.murmur = {
    enable = true;
    package = pkgs.murmur;
    port = 64738;
    openFirewall = true;
    environmentFile = "/var/lib/murmur/murmurd.env";
    password = "$MURMURD_PASSWORD";
  };
}
