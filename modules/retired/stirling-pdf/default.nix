{ ... }:
let
  directories = [
    "/opt/stirling"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0755 share share - -") directories;
  virtualisation.oci-containers.containers.pdf-tools = {
    image = "frooodle/s-pdf:latest";
    autoStart = true;
    ports = [
      "8060:8080"
    ];
    volumes = [
      "/opt/stirling/training-data:/usr/share/tesseract-ocr/4.00/tessdata"
      "/opt/stirling/configs:/configs"
    ];
    environment = {
      DOCKER_ENABLE_SECURITY = "false";
    };
  };
}
