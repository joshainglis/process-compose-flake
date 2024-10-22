{ lib, bash, ... }:
/*
  https://github.com/F1bonacc1/process-compose/blob/6b724f8d2bc3ad0308b2462c47ff2f55cb893199/src/command/config.go#L3-L8

  type ShellConfig struct {
   	ShellCommand     string `yaml:"shell_command"`
   	ShellArgument    string `yaml:"shell_argument"`
   	ElevatedShellCmd string `yaml:"elevated_shell_command"`
   	ElevatedShellArg string `yaml:"elevated_shell_argument"`
  }
*/
let
  inherit (lib) types mkOption getExe;
in
{
  options = {
    shell_command = mkOption {
      type = types.str;
      description = ''
        The shell to use to run the process `command`s.

        For reproducibility across systems, by default this uses
        `pkgs.bash`.
      '';
      default = getExe bash;
      defaultText = "lib.getExe pkgs.bash";
    };

    shell_argument = mkOption {
      type = types.str;
      default = "-c";
      example = "-c";
      description = ''
        Arguments to pass to the shell given by `shell_command`.
      '';
    };

    elevated_shell_command = mkOption {
      type = types.str;
      description = ''
        The shell to use to run the process `command`s with elevated privileges.

        For reproducibility across systems, by default this uses
        `pkgs.bash`.
      '';
      default = getExe bash;
      defaultText = "lib.getExe pkgs.bash";
    };
  };
}
