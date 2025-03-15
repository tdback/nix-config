# modules/profiles/fstrim/default.nix
#
# Routinely discard unused blocks in the filesystem on supported SSDs.

{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
