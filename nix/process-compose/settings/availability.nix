{ lib, ... }:
/*
  https://github.com/F1bonacc1/process-compose/blob/6b724f8d2bc3ad0308b2462c47ff2f55cb893199/src/types/process.go#L255-L261

  type RestartPolicyConfig struct {
  Restart        string `yaml:",omitempty"`
  BackoffSeconds int    `yaml:"backoff_seconds,omitempty"`
  MaxRestarts    int    `yaml:"max_restarts,omitempty"`
  ExitOnEnd      bool   `yaml:"exit_on_end,omitempty"`
  ExitOnSkipped  bool   `yaml:"exit_on_skipped,omitempty"`
  }
*/
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
      type = types.ints.unsigned;
      example = 5;
      description = ''
        BackoffSeconds is the number of seconds to wait before restarting
      '';
    };

    max_restarts = mkOption {
      type = types.ints.unsigned;
      example = 5;
      description = ''
        MaxRestarts is the maximum number of restarts before giving up
      '';
    };

    exit_on_end = mkOption {
      type = types.bool;
      example = true;
      description = ''
        ExitOnEnd exits the process when it ends
      '';
    };

    exit_on_skipped = mkOption {
      type = types.bool;
      example = true;
      description = ''
        ExitOnSkipped exits the process when it is skipped
      '';
    };
  };
}
