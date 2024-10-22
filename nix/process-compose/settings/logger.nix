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
      default = null;
      description = ''
        Log rotation settings
      '';
    };

    fields_order = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      example = [ "timestamp" "level" "msg" ];
      description = ''
        FieldsOrder is the order in which fields are logged
      '';
    };

    disable_json = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        DisableJSON disables log JSON formatting
      '';
    };

    timestamp_format = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "2006-01-02T15:04:05.000Z07:00";
      description = ''
        TimestampFormat is the format of the timestamp
      '';
    };

    no_color = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        NoColor disables coloring
      '';
    };

    no_metadata = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        NoMetadata disables log metadata (process, replica)
      '';
    };

    add_timestamp = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        AddTimestamp adds timestamp to log
      '';
    };

    flush_each_line = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        FlushEachLine flushes the logger on each line
      '';
    };
  };
}
