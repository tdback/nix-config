{
  inputs,
  config,
  lib,
  ...
}:
{
  nix.settings = {
    trusted-users = [
      "@wheel"
      "root"
    ];
    # Experimental?! How about always enable!
    experimental-features = lib.mkDefault [
      "nix-command"
      "flakes"
    ];
    # During builds, save disk space by replacing duplicates with a hard-link
    # to a single copy. This may slow down some builds.
    auto-optimise-store = true;
  };

  # Periodically clean the store and remove older boot entries. We could also
  # limit boot entries with `boot.loader.systemd-boot.configurationLimit`, but
  # this should be frequent enough.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
    # Allow choice between stable and unstable pkgs.
    overlays = [
      (final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      })
    ];
  };

  security.polkit.enable = true;
  security.sudo = {
    enable = lib.mkDefault true;
    wheelNeedsPassword = lib.mkDefault false;
  };

  # /tmp is mounted in RAM. This makes tmp file management go BRRRR on SSDs and
  # also more secure (and volatile). The tmpfs is wiped on reboot.
  boot.tmp.useTmpfs = lib.mkDefault true;
  # If not using tmpfs (purged on reboot), we must clean it ourselves.
  boot.tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

  # Fix security hole in place for backwards compatibility. See desc in
  # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
  boot.loader.systemd-boot.editor = false;

  # Tweak runtime kernel parameters.
  boot.kernel.sysctl = {
    # Disable "Magic SysRq" key, since we don't need it.
    "kernel.sysrq" = 0;
    # Don't accept IP source packets (we aren't a router).
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (we still aren't a router).
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Refuse ICMP redirects (MITM mitigation).
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protect against SYN flood attacks.
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection against TIME-WAIT assassination.
    "net.ipv4.tcp_rfc1337" = 1;
    # Mitigate IP spoofing with reverse path filtering. This forces the kernel
    # to do source validation of packets received from all interfaces.
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    # Reduce network latency by packing data in sender's initial TCP SYN.
    # A value of '3' enables TCP Fast Open for both incoming and outgoing
    # connections.
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations and slight improvement in throughput and latency.
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
  };
  boot.kernelModules = [ "tcp_bbr" ];

  # Ensure these programs are *always* installed.
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
