{
  lib,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  pkg-config,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "macmon";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    rev = "v${version}";
    hash = "sha256-jKL4z/N3n3CqtxhMbwyYGzXI/1xeg+umRBJ+vPVWfMI=";
  };

  cargoHash = "sha256-/8/TOYp8nO+DeSx0sFlBI7b7L+VhwXMu3m1pnYpUme4=";

  nativeBuildTools = [pkg-config];

  buildInputs =
    []
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.IOKit
      darwin.Libsystem
      darwin.PowerManagement
    ]);

  meta = with lib; {
    description = "Sudoless performance monitoring for Apple Silicon processors. CPU / GPU / RAM usage, power consumption & temperature";
    homepage = "https://github.com/vladkens/macmon";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "macmon";
  };
}
