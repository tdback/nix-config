{ pkgs, ... }:
{
  networking.nameservers = [ "9.9.9.9" ];

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      dnsovertls = "true";
    };
  };
}
