{
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  # libptytty,
  darwin,
  lib,
  stdenv,
  # nodePackages,
  # python3,
  # pkg-config,
  # gcc,
  # libgcc,
  # libcxx,
  # libcxxabi,
  # llvmPackages,
  # gitUpdater,
  # clang,
  # vips,
  cacert,
  autoPatchelfHook,
  patchelf,
}:
buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.16";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "${version}";
    hash = "sha256-jqLYN251ZvLOjYsSQJmvQ1TupO4jz3Q23aDpKX+Puvs=";
  };

  passthru = {
    updateScript = nix-update-script {};
  };

  npmDepsHash = "sha256-rGUyA0RLnNZ6ocmHPXfBLJ6ZmeeTN9w+TJTtfTQQ24M=";

  postInstall = ''
    mkdir -p $out/share
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
