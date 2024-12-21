{ inputs, config, lib, ... }:
let
  # TODO: Think about changing this to config.networking.interface...
  # Will have to pull the first value in the list, which might be messy but it
  # will definitely make it more producible across machines.
  ip = "10.0.0.203";
  interface = "eno1";
  directory = "/opt/pihole";
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0755 share share - -") (lib.lists.singleton directory);

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    autoStart = true;
    ports = [
      "53:53/udp"
      "53:53/tcp"
      "80:80/tcp"
    ];
    volumes = [
      "${directory}/etc:/etc/pihole"
      "${directory}/etc-dnsmasq.d:/etc/dnsmasq.d"
    ];
    environment = {
      TZ = "America/Detroit";
      FTLCONF_LOCAL_IPV4 = ip;
      INTERFACE = interface;
    };
    extraOptions = [ "--network=host" ];
  };

  age.secrets.piholeAdminPass = {
    file = "${inputs.self}/secrets/piholeAdminPass.age";
    mode = "770";
    owner = "share";
    group = "share";
  };

  systemd.services.podman-pihole.postStart =
    let
      password = config.age.secrets.piholeAdminPass.path;
    in ''
      podman exec -it pihole pihole -a -p "$(tr -d '\n' < ${password})"
    '';

  networking.firewall = {
    allowedTCPPorts = [ 53 80 ];
    allowedUDPPorts = [ 53 ];
  };
}
