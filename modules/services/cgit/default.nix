{ inputs, lib, pkgs, ... }:
let
  scanPath = "/tank/git";
  domain = "git.tdback.net";
in
{
  imports = lib.lists.singleton "${inputs.self}/modules/customs/cgit";

  services.cgit = {
    enable = true;
    package = pkgs.cgit;
    scanPath = scanPath;
    virtualHost = domain;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzLpTEoej7P04KoNzokQ9IOnNZiKyi2+YQ8yU5WSKCb"
    ];
    settings = {
      root-title = domain;
      root-desc = "tdback's git repositories";
      enable-index-links = 1;
      enable-index-owner = 0;
      enable-commit-graph = 1;
      enable-log-filecount = 1;
      enable-log-linecount = 1;
      readme = ":README.md";
    };
  };
}
