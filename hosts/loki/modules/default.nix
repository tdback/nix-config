{
  inputs,
  ...
}:
{
  modules = {
    services.matrix = {
      enable = true;
      url = "tdback.net";
      registrationSecret = "${inputs.self}/secrets/synapseRegistration.age";
      coturnStaticAuth = "${inputs.self}/secrets/coturnStaticAuth.age";
    };
    scripts.motd = {
      enable = true;
      networkInterfaces = [ "enp1s0" ];
      servicesToCheck = [
        "coturn"
        "matrix"
        "postgresql"
      ];
    };
  };
}
