{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      helpers = import ./modules { inherit inputs; };
      inherit (helpers) mergeSets mkSystem;
    in
    {
      nixosConfigurations = mergeSets [
        (mkSystem "frigg" "x86_64-linux" inputs.nixpkgs [
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
              "cgit"
              "proxy"
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
              "share"
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
              "proxy"
              "ssh"
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
              "web"
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
            ];
          }
        ))
      ];
    };
}
