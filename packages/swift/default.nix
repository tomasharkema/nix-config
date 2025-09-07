{
  lib,
  stdenv,
  cmake,
  coreutils,
  glibc,
  gccForLibs,
  which,
  perl,
  libedit,
  ninja,
  pkg-config,
  sqlite,
  libxml2,
  clang_18,
  python3,
  ncurses,
  libuuid,
  icu,
  libgcc,
  libblocksruntime,
  curl,
  rsync,
  git,
  libgit2,
  fetchFromGitHub,
  makeWrapper,
  gnumake,
  file,
  openssl,
  cacert,
}: let
  versions = {
    swift = "6.1.2";
  };

  python = python3.withPackages (ps: [ps.six]);
in
  stdenv.mkDerivation {
    pname = "swift";
    version = versions.swift;

    nativeBuildInputs = [
      cmake
      git
      makeWrapper
      ninja
      perl
      pkg-config
      python
      rsync
      which
    ];

    buildInputs = [
      curl
      glibc
      icu
      libblocksruntime
      libedit
      libgcc
      libuuid
      libxml2
      ncurses
      sqlite
      clang_18
    ];

    # TODO: Revisit what needs to be propagated and how.
    propagatedBuildInputs = [
      libgcc
      libgit2
      python
    ];

    propagatedUserEnvPkgs = [git pkg-config];

    hardeningDisable = ["format"]; # for LLDB

    src = fetchFromGitHub {
      owner = "swiftlang";
      repo = "swift";
      rev = "swift-${versions.swift}-RELEASE";
      fetchSubmodules = true;
      leaveDotGit = true; # otherwise, utils/update-checkout fails
      nativeBuildInputs = [python git openssl cacert];
      postFetch = ''
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";

        ls -la
        ls -la $out

        # mkdir -p $out/swift

        # mv $out/.* $out/swift
        # mv $out/* $out/swift || true

        patchShebangs $out/utils/update-checkout

        $out/utils/update-checkout --clone --clean --tag swift-${versions.swift}-RELEASE --source-root $out --skip-history -j1
        ls -lsa $out
      '';
      #sha256 = "sha256-JrewdK05fSEkaqsGxWQB2J9N7w6XYxV7qbUdKNKy110e8=";
    };

    # configurePhase = ''
    #   # do nothing here
    # '';

    buildPhase = ''
      ls -lsa
      pwd
      ls -lsa $out
      utils/build-script \
        --clean\
        --install-prefix $out \
        --install-all \
        --lto \
        --static-libxml2 \
        --static-zlib \
        --static-curl \
        --build-swift-static-stdlib \
        --build-swift-static-sdk-overlay \
        --build-swift-stdlib-static-print
    '';

    meta = with lib; {
      description = "The Swift Programming Language";
      homepage = "https://github.com/swiftlang/swift";
      maintainers = with maintainers; []; # TODO update maintainers
      license = licenses.asl20;
      # Swift doesn't support 32-bit Linux, unknown on other platforms.
      platforms = platforms.linux;
      badPlatforms = platforms.i686;
      timeout = 86400; # 24 hours.
    };
  }
