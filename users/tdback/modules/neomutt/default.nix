{ pkgs, ... }:
{
  programs.neomutt = {
    enable = true;
    package = pkgs.unstable.neomutt;

    vimKeys = true;
    sort = "reverse-date";

    checkStatsInterval = 60;

    sidebar = {
      enable = true;
      shortPath = true;
      width = 20;
    };

    binds = [
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\Cp";
        action = "sidebar-prev";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\Cn";
        action = "sidebar-next";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\Cy";
        action = "sidebar-open";
      }
    ];

    macros = [
      {
        map = [
          "index"
          "pager"
        ];
        key = "gi";
        action = "<change-folder>=Inbox<enter>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "gs";
        action = "<change-folder>=Sent<enter>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "gd";
        action = "<change-folder>=Drafts<enter>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "gt";
        action = "<change-folder>=Trash<enter>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "ga";
        action = "<change-folder>=Archive<enter>";
      }
      {
        map = [ "index" ];
        key = "S";
        action = "<shell-escape>${pkgs.isync}/bin/mbsync -a<enter>";
      }
    ];
  };
}
