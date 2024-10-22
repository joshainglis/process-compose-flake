{ lib, ... }:
let
  inherit (lib) types mkOption filter hasPrefix;
  inherit (types) attrsOf anything;
in
mkOption {
  type = attrsOf anything;
  default = { };
  description = ''
    Custom extension fields. All top-level keys must start with "x-".
    Values can be of any type that can be represented in YAML.
  '';
  example = {
    "x-foo" = "bar";
    "x-baz" = 42;
    "x-qux" = [ "a" "b" "c" ];
    "x-norf" = { "a" = "b"; "c" = "d"; };
  };
  apply = attrs:
    let
      invalidKeys = filter (k: !(hasPrefix "x-" k)) (builtins.attrNames attrs);
    in
    if invalidKeys != [ ] then
      throw "Invalid extension keys: ${toString invalidKeys}. All extension keys must start with 'x-'."
    else
      attrs;
}
