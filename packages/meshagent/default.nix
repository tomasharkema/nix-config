{
  lib,
  stdenv,
  # ccacheStdenv,
  fetchFromGitHub,
  libjpeg,
  pkg-config,
  xorg,
  coreutils,
  util-linux,
}: let
  fhs = stdenv.mkDerivation {
    name = "meshagents-tools";

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p "$out/bin"

      ln -s "${coreutils}/bin/id" "$out/bin/id"
      ln -s "${util-linux}/bin/last" "$out/bin/last"
      ln -s "${util-linux}/bin/script" "$out/bin/script"
    '';
  };
in
  # ccacheStdenv
  stdenv.mkDerivation rec {
    pname = "meshagent";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "Ylianst";
      repo = "MeshAgent";
      rev = "MeshCentral_v${version}";
      hash = "sha256-mppTMYUT+aSj2j4NNAiyimO8hEozHEIrmqNKaucnn6U=";
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      libjpeg
      xorg.libX11.dev
      xorg.xorgproto
      xorg.libXtst
      xorg.xinput
      xorg.libXi
    ];

    # MESH_AGENTID = "6";
    # ARCHID = "6";

    buildPhase = ''
      runHook preBuild

      for filename in modules/*.js; do
        substituteInPlace "$filename" \
          --replace "/usr/bin" "${fhs}/bin" \
          --replace "PATH=" "PATH=${fhs}/bin:/run/current-system/sw/bin:/run/current-system/sw/sbin"
      done

      make linux ARCHID=6 DEBUG=1 WEBLOG=1 # Linux x86 64 bit

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp meshagent_x86-64 $out/bin/meshagent
    '';

    checkPhase = ''
      $out/bin/meshagent --selfTest=1
    '';

    passthru.fhs = fhs;

    meta = with lib; {
      description = "MeshAgent used along with MeshCentral to remotely manage computers. Many variations of the background management agent are included as binaries in the MeshCentral project";
      homepage = "https://github.com/Ylianst/MeshAgent";
      license = licenses.unfree; # FIXME: nix-init did not found a license
      maintainers = with maintainers; [];
      mainProgram = "meshagent";
      platforms = platforms.all;
    };
  }
