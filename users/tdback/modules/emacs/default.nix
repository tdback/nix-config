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
        jinx
        mu4e
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

  # Include dictionaries for spell checking.
  home.packages = with pkgs.unstable; [
    enchant
    hunspellDicts.en-us-large
  ];
}
