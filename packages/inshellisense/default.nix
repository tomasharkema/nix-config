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
}:
buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.14";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "${version}";
    hash = "sha256-ZsEAE9EDJLREpKjHLbvqAUNM/y9eCH44g3D8NHYHiT4=";
  };

  passthru.updateScript = gitUpdater {
    url = "https://github.com/microsoft/inshellisense.git";
    rev-prefix = "grpc-tools@";
  };

  npmDepsHash = "sha256-p0/GnAdWNM/wjB/w+rXbOrh3Hr/smIW0IVQga7uCKYY=";

  postInstall = ''
    cp -r shell $out/share
  '';

  nativeBuildInputs = [pkg-config];

  buildInputs =
    (
      if stdenv.isDarwin
      then [darwin.Libsystem nodePackages.node-gyp-build python3]
      else []
    )
    ++ [
      gcc
      libgcc
      libcxx
      libcxxabi
      nodePackages.node-gyp-build
      nodePackages.node-gyp
      python3
      llvmPackages.libcxxStdenv
    ];
  meta = {maintainers = lib.maintainers.tomas;};
}
