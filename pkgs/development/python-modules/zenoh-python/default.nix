{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cargo,
  rustPlatform,
  rustc,
  stdenv,
  darwin,
}:

buildPythonPackage rec {
  pname = "zenoh-python";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-python";
    rev = version;
    hash = "sha256-ZFHy4R5aT6ZRUB5hKr/jkI4rSIPZHxSbMzEP746UNQQ=";
  };

  patches = [
    # don't use git in Cargo.{toml,lock}
    (fetchpatch {
      url = "https://github.com/nim65s/zenoh-python/commit/89b2aecf57f52fa33175f0ef0f858aaf6bf9e7d1.patch";
      hash = "sha256-InfHreYqqhd02CHqNtOjbL0fAiTs1aP/yLtND/lw7nk=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-oUHoCUeDTYx/iu9LtXfDCn5L8iV5WGQK89jepDOdIME=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  pythonImportsCheck = [ "zenoh" ];

  meta = {
    description = "Python API for zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-python";
    changelog = "https://github.com/eclipse-zenoh/zenoh-python/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      apsl20
      epl20
    ];
    maintainers = with lib.maintainers; [ ];
  };
}
