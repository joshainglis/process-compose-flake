{ lib, bash, ... }:
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
