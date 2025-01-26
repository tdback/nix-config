{
  config,
  ...
}:
{
  programs.irssi = {
    enable = true;
    extraConfig = ''
      settings = { core = { real_name = "${config.home.username}"; }; };
    '';
    networks = {
      liberachat = {
        nick = config.home.username;
        saslExternal = true;
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
          ssl = {
            enable = true;
            verify = true;
            certificateFile = "/home/${config.home.username}/.irssi/certs/libera.pem";
          };
        };
      };
    };
  };
}
