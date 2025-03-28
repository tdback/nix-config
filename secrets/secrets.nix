let
  systems = {
    frigg = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCvgPNEJrWjeCUmF/izLhIzaAwSNYHW9o5meYmGHGzj";
    heimdall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq0rMkFlizGPijlHKMYS9CGWJ2T1ZJHqaLozWdoySz2";
    loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+5CYbXvvC/h+5YqBkuzt1VAvkX+zj22F5g6Mq1c2yL";
    odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIByi8x1IgXBC6iw6MJoO7xIkkU4bdIaQ3Mi6zEtm+IJh";
    sol = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuwAWmjWNuDwciX9N9N0SL3jZ1IapiHmSU5NVcY6/+I";
    thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEn+C6ktSqvvwNVf1zUeNKKtZJ1QgLVhQjU83+0RvSY";
  };

  allSystems = builtins.attrValues systems;
in
{
  "coturnStaticAuth.age".publicKeys = [ systems.loki ];
  "pushoverAppToken.age".publicKeys = allSystems;
  "pushoverUserToken.age".publicKeys = allSystems;
  "synapseRegistration.age".publicKeys = [ systems.loki ];
}
