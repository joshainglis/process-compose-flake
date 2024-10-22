{ name, config, pkgs, lib, ... }:
let
  inherit (lib) types mkOption literalExpression;
in
{
  options = {
    settings = mkOption {
      default = { };
      type = types.submoduleWith {
        modules = [{
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
              type = types.attrsOf (types.submoduleWith { modules = [ ./process.nix ]; });
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
              type = types.bool;
              default = false;
              description = ''
                If true, process-compose will exit on the first error.
              '';
            };

            vars = mkOption {
              type = types.attrsOf types.anything;
              default = { };
              description = ''
                Variables to be used in the process configuration.
              '';
            };

            disable_env_expansion = mkOption {
              type = types.bool;
              default = false;
              description = ''
                If true, environment variables will not be expanded.
              '';
            };

            is_tui_disabled = mkOption {
              type = types.bool;
              default = false;
              description = ''
                If true, the TUI will be disabled.
              '';
            };
          };
        }];
      };
      example =
        # packages.${system}.watch-server becomes available
        # execute `nix run .#watch-server` or incude packages.${system}.watch-server
        # as a nativeBuildInput to your devShell
        literalExpression ''
          {
            watch-server = {
              processes = {
                backend = "''${pkgs.simple-http-server}";
                frontend = "''${pkgs.simple-http-server}";
              };
            };
          };
        '';
      description = ''
        For each attribute `x = process-compose config` a flake app and package `x` is added to the flake.
        Which runs process-compose with the declared config.
      '';
    };

    outputs.settingsFile = mkOption {
      type = types.attrsOf types.raw;
      internal = true;
      description = ''
        The settings file that will be used to run the process-compose flake.
      '';
    };

    outputs.settingsTestFile = mkOption {
      type = types.attrsOf types.raw;
      internal = true;
    };
  };
  config.outputs =
    let
      inherit (lib) mapAttrs recursiveUpdate filterAttrsRecursive pipe updateManyAttrsByPath;

      # Helper function to merge two attribute sets
      mergeAttrs = a: b: recursiveUpdate a b;

      # Function to process extensions
      processExtensions = attrs:
        let
          processAttr = name: value:
            if builtins.isAttrs value then
              let
                extensions = value.extensions or { };
                cleanValue = removeAttrs value [ "extensions" ];
                processedValue = processExtensions cleanValue;
                result = mergeAttrs processedValue extensions;
              in
              if builtins.isAttrs result then processExtensions result else result
            else
              value;
        in
        mapAttrs processAttr attrs;

      removeNullAndEmptyAttrs = attrs:
        let
          f = filterAttrsRecursive (key: value: value != null && value != { });
        in
        pipe attrs [ f f ];

      toPCJson = attrs:
        pkgs.writeTextFile {
          name = "process-compose-${name}.json";
          text = builtins.toJSON attrs;
        };

      # Function to apply all transformations
      applyTransformations = attrs:
        pipe attrs [
          processExtensions
          removeNullAndEmptyAttrs
        ];

    in
    {
      settingsFile = toPCJson (removeNullAndEmptyAttrs config.settings);
      settingsTestFile = toPCJson (removeNullAndEmptyAttrs
        (lib.updateManyAttrsByPath [
          {
            path = [ "processes" "test" ];
            update = old: old // { disabled = false; availability.exit_on_end = true; };
          }
        ]
          config.settings));
    };
}
