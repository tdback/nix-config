{
  config,
  lib,
  pkgs,
  headless ? true,
  ...
}:
{
  # Hacky way to import our desktop modules if we aren't a headless system.
  imports = (lib.optional (!headless) ./desktop.nix) ++ [
    ./modules/git
    ./modules/shell
  ];

  home = {
    username = "tdback";
    homeDirectory = "/home/tdback";
    stateVersion = "24.05";
    packages = with pkgs.unstable; [
      age
      bat
      dig
      file
      fzf
      jq
      neovim
      ripgrep
      tealdeer
      unzip
      zip
    ];
  };

  # Let home manager install and manage itself.
  programs.home-manager.enable = true;
}
