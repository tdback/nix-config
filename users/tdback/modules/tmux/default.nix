# users/tdback/modules/tmux/default.nix
#
# My multiplexer outside of emacs. Rarely used anymore unless I'm editing with
# (neo)vim.

{
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    package = pkgs.unstable.tmux;
    terminal = "tmux-256color";
    escapeTime = 0;
    baseIndex = 0;
    historyLimit = 10000;
    mouse = true;
    clock24 = true;
    secureSocket = true;
    aggressiveResize = true;
    prefix = "C-t";
    extraConfig = ''
      # Prevent detaching from tmux when closing a session.
      set -g detach-on-destroy off

      # Don't prompt for confirmation when killing panes.
      bind x kill-pane

      # Splitting panes.
      unbind v
      unbind h
      unbind %
      unbind '"'
      bind v split-window -h -c "#{pane_current_path}" # split vertically
      bind h split-window -v -c "#{pane_current_path}" # split horizontally

      # Navigating panes.
      bind ^ last-window
      bind C-h select-pane -L
      bind C-j select-pane -D
      bind C-k select-pane -U
      bind C-l select-pane -R

      # Copy mode movements.
      set-window-option -g mode-keys vi
      unbind -T copy-mode-vi Space;
      unbind -T copy-mode-vi Enter;
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"

      # Customizing status bar.
      set -g status-position bottom
      set -g status-style "bg=#050505 fg=#C5C8C6"
      set -g status-right ""
      setw -g window-status-current-format " #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F"
      setw -g window-status-format " #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F"
    '';
  };
}
