let
  systems = {
    odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIByi8x1IgXBC6iw6MJoO7xIkkU4bdIaQ3Mi6zEtm+IJh";
    thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEn+C6ktSqvvwNVf1zUeNKKtZJ1QgLVhQjU83+0RvSY";
    frigg = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCvgPNEJrWjeCUmF/izLhIzaAwSNYHW9o5meYmGHGzj";
    heimdall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq0rMkFlizGPijlHKMYS9CGWJ2T1ZJHqaLozWdoySz2";
  };

  users = {
    tdback = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIErXJtbnTYwxgqv7v5HJgd0OUAlOeEzxX7TxEyBDM+at";
  };

  allSystems = builtins.attrValues systems;
  allUsers = builtins.attrValues users;
in
{
  "pushoverAppToken.age".publicKeys = allSystems ++ allUsers;
  "pushoverUserToken.age".publicKeys = allSystems ++ allUsers;
}
