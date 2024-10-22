{ lib, ... }:
/*
   https://github.com/F1bonacc1/process-compose/blob/6b724f8d2bc3ad0308b2462c47ff2f55cb893199/src/types/logger.go#L20-L37

  type LoggerConfig struct {
      // Rotation is the configuration for logging rotation
      Rotation *LogRotationConfig `yaml:"rotation"`

      // FieldsOrder is the order in which fields are logged
      FieldsOrder []string `yaml:"fields_order,omitempty"`

      // DisableJSON disables log JSON formatting
      DisableJSON bool `yaml:"disable_json"`

      // TimestampFormat is the format of the timestamp
      TimestampFormat string `yaml:"timestamp_format"`

      // NoColor disables coloring
      NoColor bool `yaml:"no_color"`

      // NoMetadata disables log metadata (process, replica)
      NoMetadata bool `yaml:"no_metadata"`

      // AddTimestamp adds timestamp to log
      AddTimestamp bool `yaml:"add_timestamp"`

      // FlushEachLine flushes the logger on each line
      FlushEachLine bool `yaml:"flush_each_line"`
  }
*/
let
  inherit (lib) types mkOption;
in
{
  options = {

    rotation = mkOption {
      type = types.nullOr (types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./log_rotation.nix ];
      });
    };

    fields_order = mkOption {
      type = types.listOf types.str;
      example = [ "timestamp" "level" "msg" ];
      description = ''
        FieldsOrder is the order in which fields are logged
      '';
    };

    disable_json = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        DisableJSON disables log JSON formatting
      '';
    };

    timestamp_format = mkOption {
      type = types.str;
      example = "2006-01-02T15:04:05.000Z07:00";
      description = ''
        TimestampFormat is the format of the timestamp
      '';
    };

    no_color = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        NoColor disables coloring
      '';
    };

    no_metadata = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        NoMetadata disables log metadata (process, replica)
      '';
    };

    add_timestamp = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        AddTimestamp adds timestamp to log
      '';
    };

    flush_each_line = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        FlushEachLine flushes the logger on each line
      '';
    };
  };
}
