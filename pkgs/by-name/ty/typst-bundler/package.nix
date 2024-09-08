{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-bundler";
  version = "0-unstable-2024-09-08";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "packages";
    rev = "9b0ffff0bb029f3c470c2f523a119c137671a756";
    hash = "sha256-5N9UmFJgBFcVZWJ8jyx5xHWiWou8a9KjwuhruQzJwG4=";
  };

  sourceRoot = "${src.name}/bundler";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.11.0" = "sha256-+9uNtoAUjFiUO9dSh2a7n+VxZUvUz7iBGGGO0F9/U/o=";
    };
  };

  meta = {
    description = "package bundler for typst";
    homepage = "https://github.com/typst/packages";
    license = lib.licenses.asl20;
    mainProgram = "bundler";
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
