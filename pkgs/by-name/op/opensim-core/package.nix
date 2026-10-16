{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  doxygen,
  pkg-config,

  blas,
  lapack,
  casadi,
  ipopt,
  simbody,
  spdlog,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensim-core";
  version = "4.6";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "opensim-org";
    repo = "opensim-core";
    tag = finalAttrs.version;
    hash = "sha256-fZfeVeIexsOD6A0jiSaXvga5sV8TJNJOPI2WcxGKDQ8=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
    casadi
    ipopt
    simbody
    spdlog
  ];

  cmakeFlags = [
    (lib.cmakeFeature "SIMBODY_HOME" "${simbody}")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SimTK OpenSim graphical user interface and distribution";
    homepage = "https://github.com/opensim-org/opensim-core";
    changelog = "https://github.com/opensim-org/opensim-core/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
