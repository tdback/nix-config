{
  config,
  ...
}:
let
  userName = config.home.username;
  userEmail = config.accounts.email.accounts.${userName}.address or "tyler@tdback.net";
in
{
  programs.git = {
    enable = true;
    inherit userName userEmail;
    extraConfig.init.defaultBranch = "main";
  };
}
