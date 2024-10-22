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
mkOption {
  type = types.nullOr (types.attrsOf (types.submodule {
    options = {
      condition = mkOption {
        type = enum [
          "process_completed"
          "process_completed_successfully"
          "process_healthy"
          "process_log_ready"
          "process_started"
        ];
        example = "process_healthy";
        description = ''
          The condition the parent process must be in before starting the current one.
        '';
      };
      extensions = import ./extensions.nix { inherit lib; };
    };
  }));
  example = {
    "process1" = {
      condition = "process_completed";
    };
    "process2" = {
      condition = "process_healthy";
      extensions = {
        "x-custom-key" = "custom-value";
      };
    };
    description = ''
      DependsOn is a map of process names to their dependencies. The key is the name of the process that depends on another process. The value is an object with the following fields:

      - condition: The condition to wait for. It can be one of the following:
        - process_completed: Wait until the process has completed (any exit code).
        - process_completed_successfully: Wait until the process has completed successfully (exit code 0).
        - process_healthy: Wait until the process is healthy.
        - process_started: Wait until the process has started (default).
        - process_log_ready: Wait until the process has printed a predefined log line
      - extensions: Extension configuration for the dependency. This is an object with arbitrary keys and values. The keys must start with "x-" to avoid conflicts with future versions of Process Compose.
    '';
  }
