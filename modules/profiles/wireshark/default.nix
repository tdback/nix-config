{ config, pkgs, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Add any users in the 'wheel' group to the 'wireshark' group.
  users.groups.wireshark.members = let users = config.users.users; in
    builtins.attrNames users
    |> builtins.filter (
      x: builtins.elem "wheel" users.${x}.extraGroups
    );
}
