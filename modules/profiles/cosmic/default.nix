{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  # Setup binary substituter so we don't have to build everything from source.
  # If this is a first time setup, comment out the code below the nix.settings
  # attrset and run `sudo nixos-rebuild test` to update the substituters.
  nix.settings = {
    substituters = [ "https://cosmic.cachix.org" ];
    trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };

  # Use nvidia's experimental framebuffer device to remove a "phantom display"
  # detected by `cosmic-randr list`.
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

  # Enable `zwlr_data_control_manager_v1` protocol in cosmic-comp to fix the
  # clipboard manager not working properly.
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  # Enable COSMIC!
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Don't use flatpaks, which will pull in `cosmic-store`.
  services.flatpak.enable = false;

  # Don't include these packages either.
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-player
  ];

  # Install any additional fonts.
  fonts.packages = with pkgs; [
    iosevka-comfy.comfy-motion-fixed
  ];
}
