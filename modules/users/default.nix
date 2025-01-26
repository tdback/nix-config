{
  pkgs,
  ...
}:
{
  users = {
    users.tdback = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/tdback";
      group = "tdback";
      extraGroups = [
        "wheel"
        "users"
        "networkmanager"
        "video"
        "audio"
      ];
      shell = pkgs.bash;
      ignoreShellProgramCheck = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSDrYIsIPOpxB2qap2EPAREK1yupGw/GuyWkvo8IcDD"
      ];
    };
    groups.tdback.gid = 1000;
  };
}
