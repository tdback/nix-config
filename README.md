# Flake Layout
- `hosts/`
  - `frigg/` - git and SFTP server.
  - `heimdall/` - DNS and SearXNG server.
  - `loki/` - matrix and coturn server.
  - `odin/` - the "frankenNAS". Stores and serves media.
  - `sol/` - public games server for playing with friends.
  - `sparrow/` - laptop.
  - `thor/` - fediverse server, web server, and handles delegation to the matrix server.
  - `woodpecker/` - desktop.
- `modules/`
  - `containers/` - podman/docker container configurations.
  - `customs/` - overrides for existing modules in nixpkgs.
  - `profiles/` - configurations intended to be imported into a given system.
  - `scripts/` - custom shell scripts wrapped in nix (primarily for servers).
  - `services/` - service/daemon configurations.
  - `users/` - default user configuration for my systems.
- `secrets/` - [age](https://github.com/FiloSottile/age) encrypted secrets, via [agenix](https://github.com/ryantm/agenix)
- `users/` - [home-manager](https://github.com/nix-community/home-manager) configuration per user.
