{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    restart = mkOption {
      type = types.nullOr types.str;
      example = "always";
      description = ''
        Restart is the restart policy for the process
      '';
    };

    backoff_seconds = mkOption {
      type = types.nullOr types.ints.unsigned;
      example = 5;
      description = ''
        BackoffSeconds is the number of seconds to wait before restarting
      '';
    };

    max_restarts = mkOption {
      type = types.nullOr types.ints.unsigned;
      example = 5;
      description = ''
        MaxRestarts is the maximum number of restarts before giving up
      '';
    };

    exit_on_end = mkOption {
      type = types.nullOr types.bool;
      example = true;
      description = ''
        ExitOnEnd exits the process when it ends
      '';
    };

    exit_on_skipped = mkOption {
      type = types.nullOr types.bool;
      example = true;
      description = ''
        ExitOnSkipped exits the process when it is skipped
      '';
    };
  };
}
