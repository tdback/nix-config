# users/tdback/modules/editor/default.nix
#
# My primary editor for writing code, checking mail, and doing other emacs-y
# things.
#
# TODO: Use unstable epkgs to get mail working with the standalone binary.

{
  pkgs,
  ...
}:
{
  # Provide emacs and emacsclient.
  programs.emacs = {
    enable = true;
    package = pkgs.unstable.emacs30-gtk3;
    extraPackages =
      epkgs: with epkgs; [
        jinx  # spell-checker
        mu4e  # mail client
      ];
  };

  # Run emacs as a systemd daemon in graphical environments.
  services.emacs = {
    enable = true;
    package = pkgs.unstable.emacs30-gtk3;
    startWithUserSession = "graphical";
    defaultEditor = true;
    client.enable = true;
  };

  # Include any package dependencies used in my emacs configuration.
  home.packages = with pkgs.unstable; [
    nixd                       # editing nix code
    ripgrep                    # faster searches
    emacsPackages.jinx         # spell-checker package
    enchant                    # spell-checker library
    hunspellDicts.en-us-large  # spell-checker dictionary
    hledger                    # finances
    imagemagick                # viewing images
    mu                         # mail client
  ];
}
