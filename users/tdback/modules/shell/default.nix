{
  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = [ "--cmd cd" ];
    };

    bash = {
      enable = true;
      historyFile = "~/.bash_history";
      historyControl = [
        "ignoredups"
        "ignorespace"
      ];
      shellOptions = [ "histappend" ];
      initExtra = ''
        PS1="
        \[\e[34m\]\u\[\e[33m\] at \[\e[34m\]\h\[\e[33m\] in \[\e[34m\]\w
        \[\e[33m\]λ\[\e[0m\] "

        # Set sane options.
        set -o noclobber
        set -o vi
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
        EDITOR = "vi";
        KEYTIMEOUT = 1;
        LC_ALL = "en_US.UTF-8";
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
        deploy-flake = "f() { deploy .#$1 -s --remote-build --auto-rollback false && rsync -ax --delete ./ $1:/etc/nixos/; }; f";
      };
    };
  };
}
