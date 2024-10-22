{ lib, ... }:

let
  inherit (lib) types mkOption;
in
{
  options = {
    command = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "sleep 2 && pkill -f 'test_loop.bash my-proccess'";
      description = ''
        The command to run while process-compose is trying to gracefully shutdown the current process.

        Note: The `shutdown.command` is executed with all the Environment Variables of the primary process
      '';
    };

    timeout_seconds = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 10;
      description = ''
        Wait for `timeout_seconds` for its completion (if not defined wait for 10 seconds). Upon timeout, `SIGKILL` is sent to the process.
      '';
    };

    signal = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 15;
      description = ''
        If `shutdown.command` is not defined, exit the process with this signal. Defaults to `15` (SIGTERM)
      '';
    };

    parent_only = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        If `true`, only the parent process will be stopped. If yes, only signal the running process instead of its whole process group.
      '';
    };
  };
}
