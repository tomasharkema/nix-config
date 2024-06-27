{
  lib,
  inputs,
  ...
}:
with lib; rec {
  compareVersion = pkgs: lhs: rhs: let
    command = "${getExe pkgs.semver-tool} compare ${lhs} ${rhs}";
    resultPath = pkgs.runCommand "semver-${lhs}-${rhs}" {} "${command} > $out";
  in
    strings.toInt (readFile resultPath);

  assertPackage = pkgs: p: let
    originalVersion = inputs.nixpkgs.legacyPackages."${pkgs.system}"."${p}".version;
    customVersion = pkgs.custom."${p}".version;
    orderedVersion = compareVersion pkgs originalVersion customVersion;
  in
    builtins.trace "${p} orderedVersion: ${builtins.toString orderedVersion}" {
      assertion = orderedVersion < 0;
      message = "${p}: org: ${originalVersion} custom: ${customVersion} ${builtins.toString (compareVersion pkgs originalVersion customVersion)}";
    };
}
