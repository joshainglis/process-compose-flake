{ lib, ... }:
let
  inherit (lib) types mkOption;

  http_get_options =
    {
      options = {
        host = mkOption {
          type = types.nullOr types.str;
          example = "google.com";
          description = ''
            The host address which `process-compose` uses to probe the process.
          '';
        };
        path = mkOption {
          type = types.nullOr types.str;
          default = "/";
          example = "/";
          description = ''
            The path to the healtcheck endpoint.
          '';
        };
        scheme = mkOption {
          type = types.nullOr types.str;
          default = "http";
          example = "http";
          description = ''
            The protocol used to probe the process listening on `host`.
          '';
        };
        port = mkOption {
          type = types.nullOr types.port;
          example = "8080";
          description = ''
            Which port to probe the process on.
          '';
        };
        num_port = mkOption {
          type = types.nullOr types.ints.u16;
          default = null;
          example = 8080;
          description = ''
            Which port to probe the process on.
          '';
        };
      };
    };

  exec_options = {
    options = {
      command = mkOption {
        type = types.nullOr types.str;
        example = "ps -ef | grep -v grep | grep my-proccess";
        description = ''
          The command to execute
        '';
      };
      working_dir = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/tmp";
        description = ''
          The working directory to execute the command in.
        '';
      };
    };
  };
in
{
  options = {
    exec = mkOption {
      type = types.nullOr (types.submodule exec_options);
      default = null;
      description = ''
        Execution settings.
      '';
    };
    http_get = mkOption {
      type = types.nullOr (types.submodule http_get_options);
      default = null;
      description = ''
        URL to determine the health of the process.
      '';
    };
    initial_delay_seconds = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = 0;
      example = 0;
      description = ''
        Wait for `initial_delay_seconds` before starting the probe/healthcheck.
      '';
    };
    period_seconds = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = 10;
      example = 10;
      description = ''
        Check the health every `period_seconds`.
      '';
    };
    timeout_seconds = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = 3;
      example = 3;
      description = ''
        How long to wait for a given probe request.
      '';
    };
    success_threshold = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = 1;
      example = 1;
      description = ''
        Number of successful checks before marking the process `Ready`.
      '';
    };
    failure_threshold = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = 3;
      example = 3;
      description = ''
        Number of times to fail before giving up on restarting the process.
      '';
    };
  };
}
