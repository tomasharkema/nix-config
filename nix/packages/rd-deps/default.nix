{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # You also have access to your flake's inputs.
  inputs,
  # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
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
