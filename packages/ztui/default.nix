{
  rustPlatform,
  fetchCrate,
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

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yGfntSfkQ9bm/jcpXREeEhx+2BsukiLHygSlvuwcy3s=";
  };

  cargoHash = "sha256-OL/NEw8mUQJDO2ADNprHCHBwxBRBIWqCgixldYQA3zk=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl rustfmt] ++ (lib.optional stdenv.isDarwin darwin.Security);

  RUSTFMT = "${rustfmt}/bin/rustfmt";
  OPENSSL_NO_VENDOR = 1;
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "tomas";
    homepage = "https://github.com/tomasharkema/nix-config";
    license = licenses.mit;
    maintainers = ["tomasharkema" "tomas@harkema.io"];
  };

  passthru = {
    updateScript = nix-update-script {};
  };
}
