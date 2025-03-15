# users/tdback/modules/email/default.nix
#
# Archaic communication in the modern age.

{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.home.username;
  email = "tyler@tdback.net";
  provider = "fastmail.com";
in
{
  accounts.email.maildirBasePath = "Mail";
  accounts.email.accounts = {
    ${username} = {
      primary = true;
      address = email;
      userName = email;
      realName = "Tyler Dunneback";
      passwordCommand = "${lib.getExe pkgs.age} -d -i ~/.ssh/mail ~/.mail.age";

      imap = {
        host = "imap.${provider}";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.${provider}";
        port = 465;
        tls.enable = true;
      };

      mbsync = {
        enable = true;
        create = "both";
      };

      msmtp = {
        enable = true;
        extraConfig.logfile = "~/.cache/msmtp/msmtp.log";
      };
    };
  };

  # Require these programs for fetching/sending mail.
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  # Make these packages available in the cli if we are using emacs.
  home.packages =
    with pkgs.unstable;
    lib.mkIf config.programs.emacs.enable [
      mu
      mu.mu4e
    ];
}
