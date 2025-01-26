{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.customs.cgit;

  mkCgitrc =
    cfg:
    pkgs.writeText "cgitrc" (
      let
        cgitConfig = {
          css = "/cgit.css";
          logo = "/cgit.png";
          favicon = "/favicon.ico";
          about-filter = "${cfg.package}/lib/cgit/filters/about-formatting.sh";
          source-filter = "${cfg.package}/lib/cgit/filters/syntax-highlighting.py";
          enable-git-config = 1;
          enable-http-clone = 1;
          remove-suffix = 1;
          clone-url = "https://${cfg.url}/$CGIT_REPO_URL";
          scan-path = cfg.scanPath;
        };
      in
      generators.toKeyValue { } (cfg.settings // cgitConfig)
    );

  mkCgitAssets =
    pkg: files:
    strings.concatStringsSep "\n" (
      builtins.map (f: ''
        handle_path /${f} {
          root * ${pkg}/cgit/${f}
          file_server
        }
      '') files
    );
in
{
  disabledModules = [ "services/networking/cgit.nix" ];

  options.modules.customs.cgit = {
    enable = mkEnableOption "cgit";
    package = mkPackageOption pkgs "cgit" { };
    user = mkOption {
      default = "git";
      type = types.str;
    };
    group = mkOption {
      default = "git";
      type = types.str;
    };
    scanPath = mkOption {
      default = "/var/lib/cgit";
      type = types.path;
    };
    url = mkOption {
      default = null;
      type = types.str;
    };
    authorizedKeys = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
    settings = mkOption {
      default = { };
      type =
        with types;
        let
          settingType = oneOf [
            bool
            int
            str
          ];
        in
        attrsOf (oneOf [
          settingType
          (listOf settingType)
        ]);
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      config.init.defaultBranch = "main";
    };

    # Setup git user with git-shell for authenticated pushes.
    users.users.${cfg.user} = {
      isSystemUser = true;
      home = cfg.scanPath;
      group = cfg.group;
      shell = "${pkgs.git}/bin/git-shell";
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };

    users.groups.${cfg.group} = { };

    # Harden git user to prevent SSH port forwarding to other servers.
    services.openssh = {
      enable = true;
      openFirewall = true;
      startWhenNeeded = true;
      settings = {
        AllowUsers = [ cfg.user ];
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      extraConfig = ''
        Match user ${cfg.user}
          AllowTCPForwarding no
          AllowAgentForwarding no
          PermitTTY no
          X11Forwarding no
      '';
    };

    # Configure fcgiwrap instance for caddy to properly serve cgi scripts.
    # Reference: https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/networking/cgit.nix
    services.fcgiwrap.instances.cgit = {
      process = { inherit (cfg) user group; };
      socket = { inherit (config.services.caddy) user group; };
    };

    networking.firewall.allowedTCPPorts = mkIf (cfg.url != null) [
      80
      443
    ];

    services.caddy = mkIf (cfg.url != null) {
      enable = true;
      virtualHosts = {
        ${cfg.url}.extraConfig =
          let
            socket = config.services.fcgiwrap.instances.cgit.socket.address;
          in
          ''
            encode zstd gzip

            reverse_proxy unix/${socket} {
              transport fastcgi {
                env SCRIPT_FILENAME ${cfg.package}/cgit/cgit.cgi
                env CGIT_CONFIG ${mkCgitrc cfg}
              }
            }

            ${mkCgitAssets cfg.package [
              "cgit.css"
              "cgit.png"
              "favicon.ico"
              "robots.txt"
            ]}
          '';
      };
    };
  };
}
