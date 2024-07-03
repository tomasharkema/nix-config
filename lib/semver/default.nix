{
  lib,
  inputs,
  ...
}:
with lib; rec {
  compareVersion = pkgs: lhs: rhs: let
    command = "${getExe pkgs.semver-tool} compare ${versions.pad 3 lhs} ${versions.pad 3 rhs}";
    resultPath = pkgs.runCommandLocal "semver-${versions.pad 3 lhs}-${versions.pad 3 rhs}" {} "${command} > $out";
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
