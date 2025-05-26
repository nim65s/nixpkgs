{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # buildInputs
  blas,
  casadi,
  docopt_cpp,
  ipopt,
  lapack,
  simbody,
  spdlog_2,
}:

assert blas.isILP64 == lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "opensim-core";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "opensim-org";
    repo = "opensim-core";
    rev = version;
    hash = "sha256-zh46BK6GbdHY+BsJ60EyBhXci0emw6IpPGFUNn3uqqs=";
  };

  postPatch = ''
    substituteInPlace cmake/CMakeLists.txt --replace-fail \
      "get_target_property(CASADI_LIBRARY_LOCATION casadi LOCATION)" \
      "get_target_property(CASADI_LIBRARY_LOCATION casadi::casadi LOCATION)"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    blas
    casadi
    docopt_cpp
    ipopt
    lapack
    simbody
    spdlog_2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "SIMBODY_HOME" "${simbody}")
  ];

  meta = {
    description = "SimTK OpenSim C++ libraries and command-line applications, and Java/Python wrapping";
    homepage = "https://github.com/opensim-org/opensim-core";
    changelog = "https://github.com/opensim-org/opensim-core/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "opensim-core";
    platforms = lib.platforms.all;
  };
}
