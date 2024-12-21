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
  users.groups.libvirtd.members = let users = config.users.users; in
    builtins.attrNames users
    |> builtins.filter (
      x: builtins.elem "wheel" users.${x}.extraGroups
    );
}
