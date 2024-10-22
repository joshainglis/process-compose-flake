{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    directory = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/var/log";
      description = ''
        Directory to log to when filelogging is enabled
      '';
    };
    filename = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "pc.log";
      description = ''
        Filename is the name of the logfile which will be placed inside the directory
      '';
    };
    max_size_mb = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 10;
      description = ''
        MaxSize the max size in MB of the logfile before it's rolled
      '';
    };
    max_backups = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 3;
      description = ''
        MaxBackups the max number of rolled files to keep
      '';
    };
    max_age_days = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 7;
      description = ''
        MaxAge the max age in days to keep a logfile
      '';
    };
    compress = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        Compress determines if the rotated log files should be compressed
        using gzip. The default is not to perform compression.
      '';
    };
  };
}
