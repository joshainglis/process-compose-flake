{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    version = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "0.5";
      description = ''
        Version of the process-compose configuration.
      '';
    };

    log_location = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "./pc.log";
      description = ''
        File to write the logs to.
      '';
    };

    log_level = mkOption {
      type = types.nullOr (types.enum [
        "trace"
        "debug"
        "info"
        "warn"
        "error"
        "fatal"
        "panic"
      ]);
      default = null;
      example = "info";
      description = ''
        Level of logs to output.
      '';
    };

    log_length = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 3000;
      description = ''
        Log length to display in TUI mode.
      '';
    };

    log_configuration = mkOption {
      type = types.nullOr (types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./logger.nix ];
      });
      default = null;
      description = ''
        The logger configuration for the process.
      '';
    };

    log_format = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "json";
      description = ''
        Format of the logs.
      '';
    };

    processes = mkOption {
      type = types.attrsOf (types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./process.nix ];
      });
      default = { };
      description = ''
        A map of process names to their configuration.
      '';
    };

    environment = import ./environment.nix { inherit lib; };

    shell = mkOption {
      type = types.nullOr (types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./shell_config.nix ];
      });
      default = null;
      description = ''
        The shell configuration for the process.
      '';
    };

    is_strict = mkOption {
      type = types.nullOr types.bool;
      default = false;
      description = ''
        If true, process-compose will exit on the first error.
      '';
    };

    vars = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
      description = ''
        Variables to be used in the process configuration.
      '';
    };

    disable_env_expansion = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        If true, environment variables will not be expanded.
      '';
    };

    is_tui_disabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        If true, the TUI will be disabled.
      '';
    };
  };
}
