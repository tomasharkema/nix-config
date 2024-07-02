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
  cacert,
  autoPatchelfHook,
  patchelf,
}:
buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.15";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "3479c5a"; # "${version}";
    hash = "sha256-lLSTncrKQUWUmqtd+cldWZ+NCnkvi4hgVTPzdtiJfI8=";
  };

  # passthru.updateScript = gitUpdater {
  #   url = "https://github.com/microsoft/inshellisense.git";
  #   rev-prefix = "grpc-tools@";
  # };

  npmDepsHash = "sha256-Rbo5TGEgvtUpu4BItsS8mX5ZY+jg56Su9ZafvC7Dozc=";

  postInstall = ''
    cp -r shell $out/share
  '';
  # Needed for dependency `@homebridge/node-pty-prebuilt-multiarch`
  # On Darwin systems the build fails with,
  #
  # npm ERR! ../src/unix/pty.cc:413:13: error: use of undeclared identifier 'openpty'
  # npm ERR!   int ret = openpty(&master, &slave, nullptr, NULL, static_cast<winsi ze*>(&winp));
  #
  # when `node-gyp` tries to build the dep. The below allows `npm` to download the prebuilt binary.
  makeCacheWritable = stdenv.isDarwin;
  nativeBuildInputs = (lib.optional stdenv.isDarwin cacert) ++ [patchelf];
}
