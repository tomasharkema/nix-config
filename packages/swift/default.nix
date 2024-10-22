{
  stdenv,
  buildFHSUserEnv,
  fetchzip,
  system,
}: let
  version = "6.0.1";

  sources = {
    "linux-x86_64" = {
      url = "https://download.swift.org/swift-${version}-release/debian12/swift-${version}-RELEASE/swift-${version}-RELEASE-debian12.tar.gz";
      sha256 = "sha256-ca6dzlmfcMHwq8O1cSAObXmCJvPy0k6NXGvmrR6YqRM=";
    };

    "linux-aarch64" = {
      url = "https://download.swift.org/swift-${version}-release/debian12-aarch64/swift-${version}-RELEASE/swift-${version}-RELEASE-debian12-aarch64.tar.gz";
      sha256 = "";
    };
  };

  swift = {src}:
    stdenv.mkDerivation {
      inherit src version;

      outputs = ["out" "bin" "include" "lib" "libexec" "local" "share"];

      name = "swift";

      dontAutoPatchelf = true;

      unpackPhase = ''
        mkdir -p usr
        cp -r ${src}/usr/* usr/
      '';

      installPhase = ''
        cp -r usr $out
        cp -r usr/bin $bin
        cp -r usr/include $include
        cp -r usr/lib $lib
        cp -r usr/libexec $libexec
        cp -r usr/local $local
        cp -r usr/share $share
      '';
      patchPhase = '''';
    };

  fhs = {swift-der}:
    buildFHSUserEnv {
      name = "fhs-swift";
      targetPkgs = pkgs: [
        pkgs.python3
        pkgs.libxml2
        swift-der
        pkgs.libuuid
        pkgs.sqlite
        pkgs.ncurses
        pkgs.pkg-config
        pkgs.gcc-unwrapped
        pkgs.glibc.dev
        pkgs.bintools-unwrapped
        pkgs.libz
        pkgs.git
        pkgs.curl
      ];
      # Fixes 'libncurses.so.6 not found'. There's probably a better way?
      profile = ''
        export LD_LIBRARY_PATH="/usr/lib64/:/usr/lib/:$LD_LIBRARY_PATH"
      '';

      # runScript = "${swift-der}/bin/swift";
    };

  srcLoc =
    if stdenv.hostPlatform.isAarch64
    then sources.linux-aarch64
    else sources.linux-x86_64;

  src = fetchzip {
    url = srcLoc.url;
    sha256 = srcLoc.sha256;
  };
in
  fhs {
    swift-der = swift {
      inherit src;
    };
  }
