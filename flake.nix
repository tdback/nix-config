{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.agenix.url = "github:ryantm/agenix";
  inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";

  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs =
    { ... }@inputs:
    let
      helpers = import ./modules { inherit inputs; };
      inherit (helpers) mergeSets mkSystem;
    in
    mergeSets [
      (mkSystem "frigg" "x86_64-linux" inputs.nixpkgs [
        {
          type = "customs";
          modules = [ "cgit" ];
        }
        {
          type = "profiles";
          modules = [
            "common"
            "upgrade"
            "wireguard"
            "zfs"
          ];
        }
        {
          type = "scripts";
          modules = [
            "motd"
            "pushover"
            "zquota"
          ];
        }
        {
          type = "services";
          modules = [
            "llm"
            "sftpgo"
            "ssh"
          ];
        }
      ])
      (mkSystem "heimdall" "x86_64-linux" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [
            "common"
            "upgrade"
          ];
        }
        {
          type = "scripts";
          modules = [
            "motd"
            "pushover"
          ];
        }
        {
          type = "services";
          modules = [
            "dns"
            "searx"
            "ssh"
          ];
        }
      ])
      (mkSystem "loki" "aarch64-linux" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [
            "common"
            "upgrade"
          ];
        }
        {
          type = "scripts";
          modules = [
            "motd"
            "pushover"
          ];
        }
        {
          type = "services";
          modules = [
            "matrix"
            "ssh"
          ];
        }
      ])
      (mkSystem "odin" "x86_64-linux" inputs.nixpkgs [
        {
          type = "containers";
          modules = [
            "freshrss"
            "jellyfin"
            "lubelogger"
            "pinchflat"
            "vaultwarden"
            "watchtower"
          ];
        }
        {
          type = "profiles";
          modules = [
            "common"
            "podman"
            "upgrade"
            "wireguard"
            "zfs"
          ];
        }
        {
          type = "scripts";
          modules = [
            "motd"
            "pushover"
            "zquota"
          ];
        }
        {
          type = "services";
          modules = [
            "immich"
            "ssh"
          ];
        }
      ])
      (mkSystem "sol" "x86_64-linux" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [
            "common"
            "upgrade"
          ];
        }
        {
          type = "scripts";
          modules = [
            "motd"
            "pushover"
          ];
        }
        {
          type = "services";
          modules = [
            "ssh"
            "xonotic"
          ];
        }
      ])
      (mkSystem "sparrow" "x86_64-linux" inputs.nixpkgs (
        inputs.nixpkgs.lib.singleton {
          type = "profiles";
          modules = [
            "common"
            "vpn"
            "xorg"
            "zsa"
          ];
        }
      ))
      (mkSystem "thor" "x86_64-linux" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [
            "common"
            "upgrade"
            "wireguard"
          ];
        }
        {
          type = "scripts";
          modules = [
            "motd"
            "pushover"
          ];
        }
        {
          type = "services";
          modules = [
            "fediverse"
            "ssh"
            "website"
          ];
        }
      ])
      (mkSystem "woodpecker" "x86_64-linux" inputs.nixpkgs (
        inputs.nixpkgs.lib.singleton {
          type = "profiles";
          modules = [
            "common"
            "fstrim"
            "libvirtd"
            "nvidia"
            "steam"
            "wireshark"
            "xorg"
            "zsa"
          ];
        }
      ))
    ];
}
