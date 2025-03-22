# users/tdback/modules/browser/default.nix
#
# Because google sucks.

{
  config,
  lib,
  pkgs,
  ...
}:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs.librewolf = {
    enable = true;
    package = pkgs.unstable.librewolf;

    # Tweak settings in about:config.
    policies.Preferences = {
      "extensions.screenshots.disabled" = lock-true;
      "browser.topsites.contile.enabled" = lock-false;
      "browser.formfill.enable" = lock-false;
      "browser.search.suggest.enabled" = lock-false;
      "browser.search.suggest.enabled.private" = lock-false;
      "browser.urlbar.suggest.searches" = lock-false;
      "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
      "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
      "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
      "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
      "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
      "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
    };

    policies.ExtensionSettings = {
      # Block all extensions except those defined below.
      "*".installation_mode = "blocked";

      # uBlock Origin
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };

      # Bitwarden
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };

      # Dark Reader
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
      };
    };

    # Setup a default profile for our user.
    profiles.${config.home.username}.search = {
      force = true;
      default = "searx";
      order = [ "searx" ];
      engines = {
        "Amazon.com".metaData.hidden = true;
        "Bing".metaData.hidden = true;
        "eBay".metaData.hidden = true;
        "Google".metaData.hidden = true;
        "Wikipedia (en)".metaData.alias = "@w";
        "searx" = {
          urls = lib.singleton {
            template = "http://10.44.4.100:8888/?q={searchTerms}";
          };
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@sx" ];
        };
      };
    };
  };
}
