{ name, config, pkgs, lib, ... }:
let
  inherit (lib) types mkOption literalExpression;
in
{
  options = {
    settings = mkOption {
      default = { };
      type = types.submoduleWith {
        specialArgs = { inherit lib; };
        modules = [ ./project.nix ];
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
      removeNullAndEmptyAttrs = attrs:
        let
          f = lib.filterAttrsRecursive (key: value: value != null && value != { });
          # filterAttrsRecursive doesn't delete the *resulting* empty attrs, so we must
          # evaluate it again and to get rid of it.
        in
        lib.pipe attrs [ f f ];
      toPCJson = attrs:
        pkgs.writeTextFile {
          name = "process-compose-${name}.json";
          text = builtins.toJSON attrs;
        };
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
