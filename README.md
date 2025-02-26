# Flake Layout
- `hosts/`
  - `frigg/` - my git and SFTP server.
  - `heimdall/` - my DNS and SearXNG server.
  - `loki/` - my matrix and coturn server.
  - `odin/` - my media server and makeshift NAS. Media is stored in a RAID-Z2
  ZFS pool for redundancy, with a caching drive for increased read performance.
  - `sparrow/` - my laptop.
  - `thor/` - my "social" server. Hosts my fediverse server, website, and
  handles delegation to my matrix server.
  - `woodpecker/` - my desktop.
- `modules/`
  - `containers/` - podman/docker container configurations.
  - `customs/` - overrides for existing modules in nixpkgs.
  - `profiles/` - configurations intended to be imported into a given system.
  - `scripts/` - custom shell scripts wrapped in nix (primarily for servers).
  - `services/` - service/daemon configurations.
  - `users/` - default user configuration for my systems.
- `secrets/` - [age](https://github.com/FiloSottile/age) encrypted secrets, via
  [agenix](https://github.com/ryantm/agenix)
- `users/` - [home-manager](https://github.com/nix-community/home-manager)
  configuration per user.
