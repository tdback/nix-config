{
  description = "One flake to rule them all.";

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
        "customs/cgit"
        "profiles/common"
        "profiles/upgrade"
        "profiles/wireguard"
        "profiles/zfs"
        "scripts/motd"
        "scripts/pushover"
        "services/dns"
        "services/ssh"
      ])
      (mkSystem "heimdall" "x86_64-linux" inputs.nixpkgs [
        "profiles/common"
        "profiles/upgrade"
        "scripts/motd"
        "scripts/pushover"
        "services/dns"
        "services/searx"
        "services/ssh"
      ])
      (mkSystem "loki" "aarch64-linux" inputs.nixpkgs [
        "profiles/common"
        "profiles/upgrade"
        "scripts/motd"
        "scripts/pushover"
        "services/matrix"
        "services/ssh"
      ])
      (mkSystem "odin" "x86_64-linux" inputs.nixpkgs [
        "containers/freshrss"
        "containers/jellyfin"
        "containers/lubelogger"
        "containers/pinchflat"
        "containers/vaultwarden"
        "containers/watchtower"
        "profiles/common"
        "profiles/podman"
        "profiles/upgrade"
        "profiles/wireguard"
        "profiles/zfs"
        "scripts/motd"
        "scripts/pushover"
        "scripts/zquota"
        "services/ssh"
      ])
      (mkSystem "sol" "x86_64-linux" inputs.nixpkgs [
        "profiles/common"
        "profiles/upgrade"
        "scripts/motd"
        "scripts/pushover"
        "services/ssh"
        "services/xonotic"
      ])
      (mkSystem "sparrow" "x86_64-linux" inputs.nixpkgs [
        "profiles/common"
        "profiles/vpn"
        "profiles/xorg"
        "profiles/zsa"
      ])
      (mkSystem "thor" "x86_64-linux" inputs.nixpkgs [
        "profiles/common"
        "profiles/upgrade"
        "profiles/wireguard"
        "scripts/motd"
        "scripts/pushover"
        "services/fediverse"
        "services/ssh"
        "services/website"
      ])
      (mkSystem "woodpecker" "x86_64-linux" inputs.nixpkgs [
        "profiles/common"
        "profiles/fstrim"
        "profiles/libvirtd"
        "profiles/nvidia"
        "profiles/steam"
        "profiles/wireshark"
        "profiles/xorg"
        "profiles/zsa"
      ])
    ];
}
