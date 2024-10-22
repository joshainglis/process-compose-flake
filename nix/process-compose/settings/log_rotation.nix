{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    directory = mkOption {
      type = types.str;
      example = "/var/log";
      description = ''
        Directory to log to when filelogging is enabled
      '';
    };
    filename = mkOption {
      type = types.str;
      example = "pc.log";
      description = ''
        Filename is the name of the logfile which will be placed inside the directory
      '';
    };
    max_size_mb = mkOption {
      type = types.ints.unsigned;
      example = 10;
      description = ''
        MaxSize the max size in MB of the logfile before it's rolled
      '';
    };
    max_backups = mkOption {
      type = types.ints.unsigned;
      example = 3;
      description = ''
        MaxBackups the max number of rolled files to keep
      '';
    };
    max_age_days = mkOption {
      type = types.ints.unsigned;
      example = 7;
      description = ''
        MaxAge the max age in days to keep a logfile
      '';
    };
    compress = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Compress determines if the rotated log files should be compressed
        using gzip. The default is not to perform compression.
      '';
    };
  };
}
