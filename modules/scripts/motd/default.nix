{ config, lib, pkgs, ... }:
let
  motd =
    pkgs.writeShellScriptBin "motd" ''
      #!/usr/bin/env bash
      RED="\e[31m"
      GREEN="\e[32m"
      YELLOW="\e[33m"
      BOLD="\e[1m"
      ENDCOLOR="\e[0m"

      case "$(date +'%H')" in
        [0-9]|1[0-1])
          TIME="morning"
          ;;
        1[2-7])
          TIME="afternoon"
          ;;
        *)
          TIME="evening"
          ;;
      esac

      UPTIME=$(cat /proc/uptime | cut -f1 -d.)
      UPDAYS=$((UPTIME/60/60/24))
      UPHOURS=$((UPTIME/60/60%24))
      UPMINS=$((UPTIME/60%60))
      UPSECS=$((UPTIME%60))

      MEMORY=$(free -m | awk 'NR == 2 { printf "%s/%sMB (%.2f%%)\n", $3, $2, ($3 * 100) / $2 }')

      SERVICES=$(systemctl list-units | grep -P 'podman-|${lib.strings.concatStringsSep "|" config.motd.servicesToCheck}')

      printf "\n"
      printf "''${BOLD}Good $TIME $(whoami), welcome to $(hostname)!$ENDCOLOR\n"
      printf "\n"
      ${lib.strings.concatStrings (lib.lists.forEach config.motd.networkInterfaces (x:
        "printf \"$BOLD  * %-20s$ENDCOLOR %s\\n\" \"IPv4 ${x}\" \"$(ip -4 addr show ${x} | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}')\"\n"
      ))}
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "Release" "$(awk -F= '/PRETTY_NAME/ { print $2 }' /etc/os-release | tr -d '"')"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "Kernel" "$(uname -rs)"
      printf "\n"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "CPU Usage" "$(awk '{ print $1 ", " $2 ", " $3 }' /proc/loadavg) (1, 5, 15 min)"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "Memory" "$MEMORY"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "System Uptime" "$UPDAYS days $UPHOURS hours $UPMINS minutes $UPSECS seconds"
      printf "\n"

      [ -z "$SERVICES" ] && exit

      printf "''${BOLD}Service status:$ENDCOLOR\n"
      while IFS= read -r line; do
        if [[ ! $line =~ ".service" ]] || [[ $line =~ ".mount" ]]; then
          continue
        fi
        if echo "$line" | grep -q 'failed'; then
          name=$(echo "$line" | awk '{ print $1 }' | sed 's/podman-//g')
          printf "$RED• $ENDCOLOR%-50s $RED[failed]$ENDCOLOR\n" "$name"
        elif echo "$line" | grep -q 'running'; then
          name=$(echo "$line" | awk '{ print $1 }' | sed 's/podman-//g')
          printf "$GREEN• $ENDCOLOR%-50s $GREEN[active]$ENDCOLOR\n" "$name"
        elif echo "$line" | grep -q 'exited'; then
          name=$(echo "$line" | awk '{ print $1 }' | sed 's/podman-//g')
          printf "$YELLOW• $ENDCOLOR%-50s $YELLOW[exited]$ENDCOLOR\n" "$name"
        else
          echo "service status unknown"
        fi
      done <<< "$SERVICES"
      printf "\n"
    '';
in
{
  options.motd = {
    networkInterfaces = lib.mkOption {
      description = "Network interfaces to monitor.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    servicesToCheck = lib.mkOption {
      description = "Services to validate alongside podman containers.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = {
    environment.systemPackages = [
      motd
    ];

    programs.bash.loginShellInit = ''
      [ -z "$PS1" ] && return

      if command -v motd &> /dev/null; then
        motd
      fi
    '';
  };
}
