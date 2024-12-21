{ pkgs, ... }:
{
  services.xonotic = {
    enable = true;
    package = pkgs.xonotic-dedicated;
    openFirewall = true;
    settings = {
      hostname = "tdback's Xonotic Server";
      net_address = "0.0.0.0";
      port = 26000;
      sv_motd = "GLHF! Please report any issues to @tdback on irc.libera.chat";

      # Specify bots and player count.
      maxplayers = 8;
      minplayers = 4;
      minplayers_per_team = 2;

      # Configure mutators.
      g_instagib = 0;
      g_grappling_hook = 1;
      g_jetpack = 0;
      g_vampire = 0;
    };
  };
}
