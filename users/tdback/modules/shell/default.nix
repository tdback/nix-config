# users/tdback/modules/shell/default.nix
#
# My shell environment. I opt to use bash since it comes installed by default
# on most distributions, including NixOS, and I spend a lot of time remoting
# onto servers at work.

{
  headless,
  ...
}:
{
  programs.bash = {
    enable = true;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    shellOptions = [ "histappend" ];
    initExtra = ''
      # Shell prompt.
      PS1="${if headless then ''\[\e[31m\][\h] '' else ""}\[\e[34m\]\w \[\e[33m\]λ\[\e[0m\] "

      # Sane options.
      set -o noclobber
      bind "\C-l":clear-screen
      bind "\C-p":previous-history
      bind "\C-n":next-history
    '';

    profileExtra = ''
      # Add script directories to PATH.
      PATH=$PATH:$HOME/scripts
      PATH=$PATH:$HOME/.local/bin

      # Clean up duplicate entries in PATH while preserving directory order.
      PATH="$(echo $PATH | tr ':' '\n' | awk '!a[$0]++' | tr '\n' ':' | sed 's/:$//')"
    '';

    sessionVariables = {
      BROWSER = "firefox";
      KEYTIMEOUT = 1;
      LC_ALL = "en_US.UTF-8";
      LEDGER_FILE = "$HOME/Documents/finance/2025.journal";
      LESSHISTFILE = "-";
      MANPAGER = "less -R --use-color -Dd+r -Du+b";
    };

    shellAliases = {
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -I";
      ls = "ls --color=auto";
      cat = "bat -pp";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      mkdir = "mkdir -p";
    };
  };

  # Automatically use flake environments in the editor and shell.
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
}
