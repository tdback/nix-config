{ config, pkgs, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Add any users in the 'wheel' group to the 'wireshark' group.
  users.groups.wireshark.members =
    with builtins;
    let
      users = config.users.users;
    in
    filter (u: elem "wheel" users.${u}.extraGroups) (attrNames users);
}
