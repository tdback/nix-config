{ inputs, config, pkgs, ... }:
let
  pushover = pkgs.writeShellScriptBin "pushover" ''
    set -e

    APP=$(cat ${config.age.secrets.pushoverAppToken.path})
    USER=$(cat ${config.age.secrets.pushoverUserToken.path})

    while getopts ":t:" args; do
      case "$args" in
        t)
          TITLE="$OPTARG"
          ;;
        :)
          echo "missing option argument for -$OPTARG" >&2
          exit 1
          ;;
        *)
          echo "invalid option -$OPTARG" >&2
          exit 1
          ;;
      esac
    done
    shift $((OPTIND - 1))

    MESSAGE="$*"
    if [ -z "$MESSAGE" ] || [ "$MESSAGE" = " " ]; then
      MESSAGE="No errors to report."
    fi

    /run/current-system/sw/bin/curl -s \
      --form-string "token=$APP" \
      --form-string "user=$USER" \
      --form-string "title=$TITLE" \
      --form-string "message=$MESSAGE" \
      https://api.pushover.net/1/messages.json
  '';
in {
  age.secrets = {
    pushoverAppToken.file = "${inputs.self}/secrets/pushoverAppToken.age";
    pushoverUserToken.file = "${inputs.self}/secrets/pushoverUserToken.age";
  };

  environment.systemPackages = [ pushover ];
}
