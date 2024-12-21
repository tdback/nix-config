{ pkgs, ... }:
{
  users = {
    users.tdback = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/tdback";
      group = "tdback";
      extraGroups = [ "wheel" "users" "networkmanager" "video" "audio" ];
      shell = pkgs.bash;
      ignoreShellProgramCheck = true;
    };
    groups.tdback.gid = 1000;
  };
}
