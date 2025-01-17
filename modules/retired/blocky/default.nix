{ lib, pkgs, ... }:
{
  services.blocky = {
    enable = true;
    package = pkgs.blocky;
    settings = {
      upstreams = {
        init.strategy = "fast";
        groups.default = [
          "9.9.9.9"
          "149.112.112.112"
        ];
      };
      bootstrapDns = lib.singleton {
        upstream = "https://dns.quad9.net/dns-query";
        ips = [ "9.9.9.9" ];
      };
      ports = {
        dns = 53;
        tls = 853;
        https = 443;
      };
      blocking = {
        denylists = {
          ads = [
            "https://adaway.org/hosts.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
            "https://v.firebog.net/hosts/Easylist.txt"
            "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
            "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
          ];
          malicious = [
            "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt"
            "https://v.firebog.net/hosts/Prigent-Crypto.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"
            "https://phishing.army/download/phishing_army_blocklist_extended.txt"
            "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"
            "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
            "https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts"
            "https://urlhaus.abuse.ch/downloads/hostfile/"
            "https://v.firebog.net/hosts/Prigent-Malware.txt"
          ];
          other = [
            "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"
          ];
          suspicious = [
            "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
            "https://v.firebog.net/hosts/static/w3kbl.txt"
            "https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt"
            "https://someonewhocares.org/hosts/zero/hosts"
            "https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts"
            "https://winhelp2002.mvps.org/hosts.txt"
            "https://v.firebog.net/hosts/neohostsbasic.txt"
            "https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt"
            "https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt"
          ];
          tracking-telemetry = [
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
            "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
            "https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt"
            "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt"
            "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt"
            "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt"
            "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt"
          ];
        };
        clientGroupsBlock.default = [
          "ads"
          "malicious"
          "other"
          "suspicious"
          "tracking-telemetry"
        ];
        loading = {
          concurrency = 16;
          strategy = "failOnError";
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      53
      443
      853
    ];
    allowedUDPPorts = [ 53 ];
  };
}
