{ name, lib, ... }:
let
  inherit (lib) types mkOption;
  probeType = types.submoduleWith {
    specialArgs = { inherit lib; };
    modules = [ ./probe.nix ];
  };
in
{
  options = {
    disabled = mkOption {
      type = types.nullOr types.bool;
      default = if name == "test" then true else null;
      example = true;
      description = ''
        Whether the process is disabled. Useful when a process is required to be started only in a given scenario, like while running in CI.

        Even if disabled, the process is still listed in the TUI and the REST client, and can be started manually when needed.
      '';
    };

    is_daemon = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        - For processes that start services / daemons in the background, please use the `is_daemon` flag set to `true`.
        - In case a process is daemon it will be considered running until stopped.
        - Daemon processes can only be stopped with the `$PROCESSNAME.shutdown.command` as in the example above.
      '';
    };

    command = import ./command.nix { inherit lib; } {
      description = ''
        The command or script or package that runs this process

        If a package is given, its executable is used as the command. Otherwise,
        the command string is wrapped in a `pkgs.writeShellApplication` which
        uses ShellCheck and runs the command in bash.
      '';
    };

    entrypoint = mkOption {
      type = types.nullOr types.listOf types.str;
      default = null;
      example = [ "/bin/sh" "-c" ];
      description = ''
        The entrypoint for the process.
      '';
    };

    log_location = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "./pc.my-proccess.log";
      description = ''
        Log location of the `process-compose` process.
      '';
    };

    logger_config = mkOption {
      type = types.nullOr (types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./logger.nix ];
      });
      default = null;
      description = ''
        The logger configuration for the process.
      '';
    };

    environment = import ./environment.nix { inherit lib; };

    availability = mkOption {
      type = types.nullOr (types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./availability.nix ];
      });
      default = null;
      description = ''
        The availability configuration for the process.
        This defines the restart policy of the process.
      '';
    };

    depends_on = mkOption {
      type = types.attrsOf (types.submoduleWith { modules = [ ./depends_on.nix ]; });
      default = { };
      description = ''
        The dependencies of the process.
      '';
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
      };
    };

    liveness_probe = mkOption {
      type = types.nullOr probeType;
      default = null;
      description = ''
        The settings used to check if the process is alive.
      '';
    };

    readiness_probe = mkOption {
      type = types.nullOr probeType;
      default = null;
      description = ''
        The settings used to check if the process is ready to accept connections.
      '';
    };

    ready_log_line = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "process is ready";
      description = ''
        A string to search for in the output of the command that indicates
        the process is ready. String will be part of a regex '.*{ready_log_line}.*'.
        This should be used for long running processes that do not have a
        readily accessible check for http or similar other checks.
      '';
    };

    shutdown = mkOption {
      type = types.nullOr (types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./shutdown.nix ];
      });
      default = null;
      description = ''
        The settings used to stop the process.
      '';
    };


    disable_ansi_colors = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        Whether to disable colors in the logs.
      '';
    };

    working_dir = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/tmp";
      description = ''
        The directory to run the process in.
      '';
    };

    namespace = mkOption {
      type = types.str;
      default = "default";
      description = ''
        Used to group processes together.
      '';
    };

    replicas = mkOption {
      type = types.ints.unsigned;
      default = 1;
      example = 3;
      description = ''
        The number of replicas to run.
      '';
    };

    extensions = import ./extensions.nix { inherit lib; };

    description = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "This is a process";
      description = ''
        A description of the process.
      '';
    };

    vars = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
      description = ''
        Custom variables for the process.
      '';
      example = {
        "foo" = "bar";
        "baz" = 42;
        "qux" = [ "a" "b" "c" ];
        "norf" = { "a" = "b"; "c" = "d"; };
      };
    };

    is_foreground = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        Foreground processes are useful for cases when a full `tty` access is required (e.g. `vim`, `top`, `gdb -tui`)

        - Foreground process have to be started manually (`F7`). They can be started multiple times.
        - They are available in TUI mode only.
        - To return to TUI, exit the foreground process.
        - In TUI mode, a local process will be started.
      '';
    };

    is_tty = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        Simulate TTY mode for this process
      '';
    };

    is_elevated = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        Run the process with elevated privileges.
      '';
    };

    replica_num = mkOption {
      type = types.ints.unsigned;
      default = 0;
      description = ''
        The replica number of the process.
      '';
    };

    replica_name = mkOption {
      type = types.str;
      default = "";
      description = ''
        The replica name of the process.
      '';
    };

    executable = mkOption {
      type = types.str;
      default = "";
      description = ''
        The executable of the process.
      '';
    };

    args = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        The arguments of the process.
      '';
    };
  };
}
