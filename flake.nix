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

  outputs = { ... } @ inputs: let
    helpers = import ./modules { inherit inputs; };
    inherit (helpers) mergeSets mkSystem;
  in {
    nixosConfigurations = mergeSets [
      (mkSystem "woodpecker" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [ "common" "fstrim" "libvirtd" "nvidia" "pipewire" "security" "steam" "wireshark" "x11" ];
        }
      ])
      (mkSystem "sparrow" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [ "common" "pipewire" "security" "vpn" "x11" ];
        }
      ])
      (mkSystem "frigg" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [ "common" "podman" "security" "upgrade" "wireguard" "zfs" ];
        }
        {
          type = "scripts";
          modules = [ "motd" "pushover" "zquota" ];
        }
        {
          type = "services";
          modules = [ "cgit" "proxy" "sftpgo" "ssh" ];
        }
      ])
      (mkSystem "heimdall" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [ "common" "security" "upgrade" ];
        }
        {
          type = "scripts";
          modules = [ "motd" "pushover" ];
        }
        {
          type = "services";
          modules = [ "blocky" "searx" "ssh" ];
        }
      ])
      (mkSystem "odin" inputs.nixpkgs [
        {
          type = "containers";
          modules = [ "freshrss" "jellyfin" "lubelogger" "pinchflat" "vaultwarden" "watchtower" ];
        }
        {
          type = "profiles";
          modules = [ "common" "podman" "security" "share" "upgrade" "wireguard" "zfs" ];
        }
        {
          type = "scripts";
          modules = [ "motd" "pushover" "zquota" ];
        }
        {
          type = "services";
          modules = [ "immich" "proxy" "ssh" ];
        }
      ])
      (mkSystem "thor" inputs.nixpkgs [
        {
          type = "profiles";
          modules = [ "common" "security" "upgrade" "wireguard" ];
        }
        {
          type = "scripts";
          modules = [ "motd" "pushover"];
        }
        {
          type = "services";
          modules = [ "fediverse" "proxy" "ssh" "web" ];
        }
      ])
    ];
  };
}
