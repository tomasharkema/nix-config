{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustfmt,
  lib,
  stdenv,
  darwin,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "ztui";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "erikh";
    repo = "ztui";
    rev = "v${version}";
    hash = "sha256-ZbfV0AGeLgYS4S55YVBPdYFahi1sAeDrcKmiGaHAeC4=";
  };

  cargoHash = "sha256-TJchVYBdrah/ExQfMHsMHbnlDviPbZYnY3WDryU5GS8=";

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
      "rustfsm-0.1.0" = "sha256-q7J9QgN67iuoNhQC8SDVzUkjCNRXGiNCkE8OsQc5+oI=";
    };
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl rustfmt] ++ (lib.optional stdenv.isDarwin darwin.Security);

  RUSTFMT = "${rustfmt}/bin/rustfmt";
  OPENSSL_NO_VENDOR = 1;
  RUSTC_BOOTSTRAP = 1;

  meta = {
    homepage = "https://github.com/erikh/ztui";
  };

  passthru = {
    updateScript = nix-update-script {};
  };
}
