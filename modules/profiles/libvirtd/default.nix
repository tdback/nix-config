{ config, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = false;
    };
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  programs.virt-manager.enable = true;

  # Add any users in the 'wheel' group to the 'libvirtd' group.
  users.groups.libvirtd.members =
    with builtins;
    let
      users = config.users.users;
    in
    filter (u: elem "wheel" users.${u}.extraGroups) (attrNames users);
}
