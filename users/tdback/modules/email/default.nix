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
  mailboxes = lib.attrValues config.accounts.email.accounts.${username}.folders;
in
{
  accounts.email.maildirBasePath = "mail";
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

      neomutt = {
        enable = true;
        sendMailCommand = lib.getExe pkgs.msmtp;
        extraMailboxes = mailboxes;
      };
    };
  };

  services.mbsync.enable = true;

  programs.neomutt =
    let
      mkAction =
        {
          key,
          action,
          map ? [
            "index"
            "pager"
          ],
        }:
        {
          inherit key action map;
        };
    in
    {
      enable = true;
      package = pkgs.unstable.neomutt;
      vimKeys = true;
      sort = "reverse-date";
      checkStatsInterval = 60;
      sidebar.enable = true;
      binds = [
        (mkAction {
          key = "\\Cp";
          action = "sidebar-prev";
        })
        (mkAction {
          key = "\\Cn";
          action = "sidebar-next";
        })
        (mkAction {
          key = "\\Cy";
          action = "sidebar-open";
        })
      ];
      macros = [
        (mkAction {
          key = "gi";
          action = "<change-folder>=Inbox<enter>";
        })
        (mkAction {
          key = "gs";
          action = "<change-folder>=Sent<enter>";
        })
        (mkAction {
          key = "gd";
          action = "<change-folder>=Drafts<enter>";
        })
        (mkAction {
          key = "gt";
          action = "<change-folder>=Trash<enter>";
        })
        (mkAction {
          key = "ga";
          action = "<change-folder>=Archive<enter>";
        })
        (mkAction {
          map = [ "index" ];
          key = "S";
          action = "<shell-escape>${lib.getExe pkgs.isync} -a<enter>";
        })
      ];
    };
}
