{ ... }:
{
  programs.git = {
    enable = true;
    userName = "tdback";
    userEmail = "tyler@tdback.net";
    extraConfig.init.defaultBranch = "main";
  };
}
