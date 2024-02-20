{
  rustPlatform,
  fetchCrate,
  pkgs,
  lib,
  stdenv,
  rustc,
}:
rustPlatform.buildRustPackage rec {
  pname = "ztui";
  version = "0.1.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yGfntSfkQ9bm/jcpXREeEhx+2BsukiLHygSlvuwcy3s=";
  };

  cargoHash = "sha256-OL/NEw8mUQJDO2ADNprHCHBwxBRBIWqCgixldYQA3zk=";
  # cargoDepsName = pname;

  nativeBuildInputs = with pkgs; [pkg-config];
  buildInputs = with pkgs; [openssl rustfmt];

  OPENSSL_NO_VENDOR = 1;
  RUSTC_BOOTSTRAP = 1;

  # preFixup = lib.optionalString stdenv.isDarwin ''
  #   install_name_tool -add_rpath "${rustc.unwrapped}/lib" "$out/bin/rustfmt"
  #   install_name_tool -add_rpath "${rustc.unwrapped}/lib" "$out/bin/git-rustfmt"
  # '';
}
