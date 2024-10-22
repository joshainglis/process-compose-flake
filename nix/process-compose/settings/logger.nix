{ lib, ... }:
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
