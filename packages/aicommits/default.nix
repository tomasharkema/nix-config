{
  buildNpmPackage,
  fetchFromGitHub,
  # libptytty,
  darwin,
  lib,
  stdenv,
  nodePackages,
  python3,
  pkg-config,
  gcc,
  libgcc,
  libcxx,
  libcxxabi,
  llvmPackages,
  gitUpdater,
  unstableGitUpdater,
  pnpm,
  nodejs,
  makeWrapper,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "aicommits";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "Nutlope";
    repo = "aicommits";
    rev = "604def8284361b8827087350fe6fcb6d9e2de836";
    hash = "sha256-JWZywM/pJNG2HbIuM8jqOVEMomvFmLnZjmkJfy9M1j8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-uRCQOdF2Lki3e71hMq4vDFp1921+0Ety/T+WsUmoxGA=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,bin}
    cp -r {node_modules,dist} $out/lib

    makeWrapper $out/lib/dist/cli.mjs $out/bin/aicommits

    runHook postInstall
  '';
  passthru = {
    updateScript = nix-update-script {};
  };
}
