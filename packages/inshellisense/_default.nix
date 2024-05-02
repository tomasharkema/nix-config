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
  clang,
  vips,
}:
buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.15";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "${version}";
    hash = "sha256-/6pU8ubasONPMe1qnE+Db0nzdHRQTo9fhMr7Xxjgsos="; # "sha256-ZsEAE9EDJLREpKjHLbvqAUNM/y9eCH44g3D8NHYHiT4=";
  };
  makeCacheWritable = true;
  # passthru.updateScript = gitUpdater {
  #   url = "https://github.com/microsoft/inshellisense.git";
  #   rev-prefix = "grpc-tools@";
  # };

  npmDepsHash = "sha256-rOyvFA5X3o1TCgY54XxNSg0+QotA8IUauLngTtJuRj4="; #"sha256-p0/GnAdWNM/wjB/w+rXbOrh3Hr/smIW0IVQga7uCKYY=";

  postInstall = ''
    cp -r shell $out/share
  '';

  nativeBuildInputs =
    (
      if stdenv.isDarwin
      then [darwin.cctools]
      else []
    )
    ++ [pkg-config python3];

  buildInputs =
    (
      if stdenv.isDarwin
      then [
        darwin.Libsystem
        #darwin.cctools
        nodePackages.node-gyp-build
      ]
      else []
    )
    ++ [
      vips
      clang
      gcc
      libgcc
      libcxx
      libcxxabi
      nodePackages.node-gyp-build
      nodePackages.node-gyp

      llvmPackages.libcxxStdenv
    ];
  # meta = {maintainers = lib.maintainers.tomas;};
}
