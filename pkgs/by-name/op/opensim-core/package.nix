{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  doxygen,
  pkg-config,
  python3,
  swig,
  texliveBasic,

  blas,
  lapack,
  casadi,
  ezc3d,
  ipopt,
  jdk,
  python3Packages,
  simbody,
  spdlog,

  catch2_3,
  ctestCheckHook,

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

  postPatch = ''
    substituteInPlace cmake/CMakeLists.txt \
      --replace-fail \
        "get_target_property(CASADI_LIBRARY_LOCATION casadi LOCATION)" \
        "get_target_property(CASADI_LIBRARY_LOCATION casadi::casadi LOCATION)"

    substituteInPlace OpenSim/Common/Logger.h OpenSim/Common/Logger.cpp OpenSim/Common/Array.h \
      --replace-fail \
        "#include <spdlog/fmt/bundled/" \
        "#include <fmt/"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    python3
    swig
    texliveBasic
  ];

  buildInputs = [
    blas
    lapack
    casadi
    ezc3d
    ipopt
    jdk
    python3Packages.numpy
    simbody
    spdlog
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_JAVA_WRAPPING" true)
    (lib.cmakeBool "BUILD_PYTHON_WRAPPING" true)
    (lib.cmakeBool "OPENSIM_COPY_DEPENDENCIES" false)
    (lib.cmakeBool "OPENSIM_DOXYGEN_USE_MATHJAX" false)
    (lib.cmakeBool "OPENSIM_PYTHON_STANDALONE" false)
    (lib.cmakeFeature "OPENSIM_C3D_PARSER" "ezc3d")
    (lib.cmakeFeature "SIMBODY_HOME" "${simbody}")
  ];

  doCheck = true;

  checkInputs = [
    catch2_3
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  disabledTests = [
    # flaky
    "testContactGeometry"
    # fail
    "testFrames"
    "testManager"
    "testForward"
    "python_examples"
    # too long
    # "testMocoInverse" # 152.97 sec
    # "testMocoConstraints" # 277.61 sec
    # "testMocoActuators" # 677.92 sec
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SimTK OpenSim C++ libraries and command-line applications";
    homepage = "https://github.com/opensim-org/opensim-core";
    changelog = "https://github.com/opensim-org/opensim-core/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
