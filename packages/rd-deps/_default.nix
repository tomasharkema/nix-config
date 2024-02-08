{
  lib,
  inputs,
  pkgs,
  stdenv,
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "rd-deps";

  src = pkgs.fetchFromGitHub {
    owner = "rundeck";
    repo = "rundeck-cli";
    rev = "d0037a653f9c57f1e62df7c0369205943ae147c9";
    sha256 = "sha256:IK/WHO5s5EiJMV2nMlVqHqk5L1jXk8dklkJm15DVZ1U=";
  };
  __noChroot = true;

  nativeBuildInputs = [
    pkgs.gradle_7
  ];

  buildPhase = ''
    export GRADLE_USER_HOME="/tmp/.gradledeps"

    gradle --no-daemon --no-build-cache --info --full-stacktrace --warning-mode=all \
      :rd-cli-tool:dependencies dependencies
  '';

  installPhase = ''
    mkdir -p $out
    mv /tmp/.gradledeps $out
    mv .gradle $out
  '';
}
