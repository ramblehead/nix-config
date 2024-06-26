{
  self,
  config,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in rec {
  runtimeRoot = "${config.home.homeDirectory}/box/nix-config";

  deduceRuntimePath = path: let
    rootStr = toString self;
    pathStr = toString path;
  in
    assert lib.assertMsg
    (lib.hasPrefix rootStr pathStr)
    "${pathStr} does not start with ${rootStr}";
      runtimeRoot + lib.removePrefix rootStr pathStr;
}
