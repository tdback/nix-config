{ lib, pkgs, ... }:
{
  accounts.email = {
    maildirBasePath = "mail";
    accounts.fastmail = {
      primary = true;
      address = "tyler@tdback.net";
      userName = "tyler@tdback.net";
      realName = "Tyler Dunneback";
      passwordCommand = "${lib.getExe pkgs.age} -d -i ~/.ssh/mail ~/.mail.age";

      folders = {
        inbox = "Inbox";
        drafts = "Drafts";
        sent = "Sent";
        trash = "Trash";
      };

      imap = {
        host = "imap.fastmail.com";
        port = 993;
        tls = {
          enable = true;
          certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
        };
      };

      smtp = {
        host = "smtp.fastmail.com";
        port = 465;
        tls = {
          enable = true;
          useStartTls = false;
          certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
        };
      };

      mbsync = {
        enable = true;
        create = "both";
        expunge = "none";
        subFolders = "Verbatim";
        patterns = [ "*" ];
      };

      msmtp = {
        enable = true;
        extraConfig = {
          logfile = "~/.cache/msmtp/msmtp.log";
        };
      };

      neomutt = {
        enable = true;
        sendMailCommand = "msmtp";
        mailboxType = "maildir";
        extraMailboxes = [
          "Drafts"
          "Sent"
          "Trash"
          "Archive"
        ];
      };
    };
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
  };

  services.mbsync = {
    enable = true;
    package = pkgs.isync;
    frequency = "*:0/5";
  };
}
