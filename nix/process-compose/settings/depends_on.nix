{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    condition = mkOption {
      type = types.nullOr (types.enum [
        "process_completed"
        "process_completed_successfully"
        "process_healthy"
        "process_started"
        "process_log_ready"
      ]);
      example = "process_healthy";
      description = ''
        The condition the parent process must be in before starting the current one.
      '';
    };
  };
}
