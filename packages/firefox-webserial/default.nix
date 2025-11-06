{
  lib,
  stdenv,
  fetchFromGitHub,
  platformio-core,
  cacert,
  git, #Minimal,
  tree,
}: let
  fetchPlatformio = {
    name ? "",
    hash ? "",
    nativeBuildInputs ? [],
    ...
  } @ args: let
    hash_ =
      if hash != ""
      then {
        outputHash = hash;
      }
      else {
        outputHash = "";
        outputHashAlgo = "sha256";
      };
  in
    stdenv.mkDerivation (
      args
      // {
        name = "${name}-platformio-deps";

        nativeBuildInputs =
          nativeBuildInputs
          ++ [
            git #Minimal
            platformio-core
            tree
          ];

        impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ ["GIT_PROXY_COMMAND" "NIX_GIT_SSL_CAINFO"];

        configurePhase = ''
          runHook preConfigure
          export PLATFORMIO_CORE_DIR=$TMPDIR/.platformio
          export PLATFORMIO_CACHE_DIR=$TMPDIR/.cache
          export GIT_SSL_CAINFO=${cacert}/etc/ssl/certs/ca-bundle.crt
          export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
          runHook postConfigure
        '';

        buildPhase = ''
          runHook preBuild

          pio pkg install

          runHook postBuild
        '';

        installPhase = ''
          cp -r --reflink=auto "$TMPDIR/.platformio" $out
          rm -rf $out/appstate.json $out/homestate.json
          # ls -la $out
          # find $out -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum
          tree $out
          # rm -rf $out/.platformio/.cache
        '';
        dontFixup = true;
        # dontInstall = true;
        # SSL_CERT_FILE =
        #   if
        #     (
        #       hash_.outputHash
        #       == ""
        #       || hash_.outputHash == lib.fakeSha256
        #       || hash_.outputHash == lib.fakeSha512
        #       || hash_.outputHash == lib.fakeHash
        #     )
        #   then "${cacert}/etc/ssl/certs/ca-bundle.crt"
        #   else "/no-cert-file.crt";

        outputHashMode = "recursive";
      }
      // hash_
    );
in
  stdenv.mkDerivation rec {
    pname = "firefox-webserial";
    version = "0.4.0";

    src = fetchFromGitHub {
      owner = "kuba2k2";
      repo = "firefox-webserial";
      rev = "v${version}";
      hash = "sha256-fueWxSOyPTTxJ+60jvSN8vY5F8DHdm2V8xXnFdNLAnY=";
    };

    platformIoDeps = fetchPlatformio {
      inherit pname version src sourceRoot;
      hash = "sha256-l2r2I1kR6g59z3YIt42VkVtD6sF741mn7s7gMGfQPiA=";
    };

    nativeBuildInputs = [platformio-core];

    sourceRoot = "${src.name}/native";

    buildPhase = ''
      runHook preBuild

      export PLATFORMIO_CORE_DIR=$TMPDIR/.platformio
      export PLATFORMIO_SETTING_CHECK_PLATFORMIO_INTERVAL=10000000
      cp -r $platformIoDeps $TMPDIR/.platformio
      chmod u+w $TMPDIR/.platformio

      platformio run -e linux_x86_64

      runHook postBuild
    '';

    meta = {
      description = "WebSerial API Polyfill for Mozilla Firefox browser";
      homepage = "https://github.com/kuba2k2/firefox-webserial";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [];
      mainProgram = "firefox-webserial";
      platforms = lib.platforms.all;
    };
  }
