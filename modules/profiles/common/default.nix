{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    settings = {
      trusted-users = [
        "@wheel"
        "root"
      ];
      experimental-features = lib.mkDefault [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
    overlays = [
      (final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      })
    ];
  };

  security = {
    polkit.enable = true;
    sudo = {
      enable = lib.mkDefault true;
      wheelNeedsPassword = lib.mkDefault false;
    };
  };

  programs = {
    git.enable = true;
    htop.enable = true;
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
}
