{ lib, ... }:

/*
   https://github.com/F1bonacc1/process-compose/blob/6b724f8d2bc3ad0308b2462c47ff2f55cb893199/src/types/logger.go#L3-L18

   // LogRotationConfig is the configuration for logging
  type LogRotationConfig struct {
   	// Directory to log to when filelogging is enabled
   	Directory string `yaml:"directory"`
   	// Filename is the name of the logfile which will be placed inside the directory
   	Filename string `yaml:"filename"`
   	// MaxSize the max size in MB of the logfile before it's rolled
   	MaxSize int `yaml:"max_size_mb"`
   	// MaxBackups the max number of rolled files to keep
   	MaxBackups int `yaml:"max_backups"`
   	// MaxAge the max age in days to keep a logfile
   	MaxAge int `yaml:"max_age_days"`
   	// Compress determines if the rotated log files should be compressed
   	// using gzip. The default is not to perform compression.
   	Compress bool `json:"compress" yaml:"compress"`
  }
*/
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
