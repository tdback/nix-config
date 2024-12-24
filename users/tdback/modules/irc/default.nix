{ ... }:
let
  user = "tdback";
in
{
  programs.irssi = {
    enable = true;
    extraConfig = ''
      settings = { core = { real_name = "${user}"; }; };
    '';
    networks = {
      liberachat = {
        nick = "${user}";
        saslExternal = true;
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
          ssl = {
            enable = true;
            verify = true;
            certificateFile = "/home/${user}/.irssi/certs/libera.pem";
          };
        };
      };
    };
  };
}
