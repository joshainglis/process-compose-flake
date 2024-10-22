{ lib, ... }:
/*
  https://github.com/F1bonacc1/process-compose/blob/6b724f8d2bc3ad0308b2462c47ff2f55cb893199/src/types/process.go#L255-L261

  const (
  // ProcessConditionCompleted is the type for waiting until a process has completed (any exit code).
  ProcessConditionCompleted = "process_completed"

  // ProcessConditionCompletedSuccessfully is the type for waiting until a process has completed successfully (exit code 0).
  ProcessConditionCompletedSuccessfully = "process_completed_successfully"

  // ProcessConditionHealthy is the type for waiting until a process is healthy.
  ProcessConditionHealthy = "process_healthy"

  // ProcessConditionStarted is the type for waiting until a process has started (default).
  ProcessConditionStarted = "process_started"

  // ProcessConditionLogReady is the type for waiting until a process has printed a predefined log line
  ProcessConditionLogReady = "process_log_ready"
  )

  type DependsOnConfig map[string]ProcessDependency

  type ProcessDependency struct {
  Condition  string                 `yaml:",omitempty"`
  Extensions map[string]interface{} `yaml:",inline"`
  }

*/
let
  inherit (lib) types mkOption;
  inherit (types) enum;
in
  {
    options = {
      condition = mkOption {
        type = enum [
          "process_completed"
          "process_completed_successfully"
          "process_healthy"
          "process_started"
          "process_log_ready"
        ];
        example = "process_healthy";
        description = ''
          The condition the parent process must be in before starting the current one.
        '';
      };
      extensions = import ./extensions.nix { inherit lib; };
    };
  }
