{
  lib,
  inputs,
  ...
}: rec {
  # compareVersion = pkgs: lhs: rhs: let
  #   command = "${getExe pkgs.semver-tool} compare ${versions.pad 3 lhs} ${versions.pad 3 rhs}";
  #   resultPath = pkgs.runCommand "semver-${versions.pad 3 lhs}-${versions.pad 3 rhs}" {} "${command} > $out";
  # in
  #   strings.toInt (readFile resultPath);

  assertPackage = pkgs: p: let
    originalVersion = inputs.nixpkgs.legacyPackages."${pkgs.system}"."${p}".version;
    customVersion = pkgs.custom."${p}".version;
    orderedVersion = lib.versionAtLeast originalVersion customVersion; #compareVersion pkgs originalVersion customVersion;
  in
    builtins.trace "${p} orderedVersion: ${builtins.toString orderedVersion}" {
      assertion = !orderedVersion;
      message = "${p}: org: ${originalVersion} custom: ${customVersion} ${builtins.toString (lib.versionAtLeast originalVersion customVersion)}";
    };
}
