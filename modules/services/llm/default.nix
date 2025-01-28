{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.services.llm;
in
{
  options.modules.services.llm = {
    enable = mkEnableOption "llm";
    port = mkOption {
      default = 8080;
      type = types.int;
      description = "Which port the Open-WebUI server listens to.";
    };
    subnet = mkOption {
      default = null;
      type = types.str;
      description = "The network subnet allowed to acccess Open-WebUI and the ollama API";
    };
    nvidiaGpu = mkOption {
      default = false;
      type = types.bool;
      description = "Use NVIDIA cuda for hardware acceleration.";
    };
    models = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "Automatically download these models.";
    };
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = if cfg.nvidiaGpu then "cuda" else false;
      loadModels = cfg.models;
    };

    services.open-webui = {
      enable = true;
      host = if cfg.subnet == null then "127.0.0.1" else "0.0.0.0";
      port = cfg.port;
    };

    # Only expose Open-WebUI and ollama API to the local network, since this
    # server might have a public IPv6 address.
    networking.firewall.extraCommands =
      with config.services;
      let
        api = builtins.toString ollama.port;
        web = builtins.toString open-webui.port;
      in
      mkIf (cfg.subnet != null) ''
        iptables -A nixos-fw -p tcp --source ${cfg.subnet} --dport ${api}:${api} -j nixos-fw-accept
        iptables -A nixos-fw -p tcp --source ${cfg.subnet} --dport ${web}:${web} -j nixos-fw-accept
      '';

    # Enable the proprietary NVIDIA drivers in a headless fashion.
    hardware.graphics.enable = cfg.nvidiaGpu;
    services.xserver.videoDrivers = mkIf cfg.nvidiaGpu [ "nvidia" ];
    hardware.nvidia = mkIf cfg.nvidiaGpu {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = false;
      nvidiaPersistenced = true;
    };
  };
}
