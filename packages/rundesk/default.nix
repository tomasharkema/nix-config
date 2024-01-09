{
  pkgs,
  lib,
  stdenv,
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "rundesk";
  meta = with lib; {
    mainProgram = "rundesk";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
  };

  src = pkgs.fetchFromGitHub {
    owner = "rundeck";
    repo = "rundeck-cli";
    rev = "d0037a653f9c57f1e62df7c0369205943ae147c9";
    sha256 = "sha256:IK/WHO5s5EiJMV2nMlVqHqk5L1jXk8dklkJm15DVZ1U=";
  };

  nativeBuildInputs = with pkgs; [
    gradle_7
    custom.rd-deps
  ];

  packages = with pkgs; [jre];

  # buildInputs = [ pkgs.rsync ];
  __noChroot = true;

  # rsync -a ${rd-deps}/.gradledeps/ $TMPHOME/
  # rsync -a ${rd-deps}/.gradle/ $TMPHOME/
  # chmod 777 -R $TMPHOME
  # --offline

  buildPhase = ''
    TMPHOME="$(mktemp -d)"
    mkdir -p "$TMPHOME/init.d"
    export GRADLE_USER_HOME="$TMPHOME"

    gradle :rd-cli-tool:installDist --no-daemon \
      --no-build-cache --info --full-stacktrace --warning-mode=all
  '';

  installPhase = ''
    mv rd-cli-tool/build/install/rd $out
  '';
}
