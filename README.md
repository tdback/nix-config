# Flake Layout
- `hosts/`
  - `frigg/` - my git and SFTP server.
  - `heimdall/` - my DNS server and SearXNG host.
  - `loki/` - my matrix and coturn server.
  - `odin/` - my media server and makeshift NAS. Media is stored in a RAID-Z2
  ZFS pool for redundancy, with a caching drive for increased read performance.
  - `sparrow/` - my laptop.
  - `thor/` - my "social" server responsible for hosting my fediverse server,
  website, and handling delegation to my matrix server.
  - `woodpecker/` - my desktop.
- `modules/`
  - `containers/` - podman/docker container configurations.
  - `customs/` - custom modules or overrides for existing modules in nixpkgs.
  - `profiles/` - configurations intended to be imported into a given system.
  - `retired/` - modules or configurations I don't use anymore, but want to
  keep around for reference.
  - `scripts/` - custom shell scripts wrapped in nix (primarily for servers).
  - `services/` - service/daemon configurations.
  - `users/` - default user configuration for my systems.
- `secrets/` - [age](https://github.com/FiloSottile/age) encrypted secrets, via
  [agenix](https://github.com/ryantm/agenix)
- `users/` - [home-manager](https://github.com/nix-community/home-manager)
  configuration per user.
