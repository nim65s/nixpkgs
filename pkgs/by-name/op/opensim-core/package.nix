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
  spdlog,

  # for spdlog_1_11
  fmt_9,
}:

assert blas.isILP64 == lapack.isILP64;

let
  # https://github.com/gabime/spdlog/issues/2142 is triggered
  # workarounds are to use spdlog <= 1.11.0 or > 2, but the later break opensim
  spdlog_1_11 = (spdlog.override { fmt = fmt_9; }).overrideAttrs (super: {
    version = "1.11.0";
    src = fetchFromGitHub {
      inherit (super.src) owner repo tag;
      hash = "sha256-kA2MAb4/EygjwiLEjF9EA7k8Tk//nwcKB1+HlzELakQ=";
    };
  });
in

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
    # casadi CMake export is now casadi::casadi
    substituteInPlace cmake/CMakeLists.txt --replace-fail \
      "get_target_property(CASADI_LIBRARY_LOCATION casadi LOCATION)" \
      "get_target_property(CASADI_LIBRARY_LOCATION casadi::casadi LOCATION)"

    # /build/source/OpenSim/Common/Logger.cpp:116:47: error: cannot convert
    # 'std::vector<std::shared_ptr<spdlog::sinks::sink> >::iterator' to 'const char*'
    substituteInPlace OpenSim/Common/Logger.cpp --replace-fail \
      "using namespace OpenSim;" \
      "using namespace OpenSim;
       #include <algorithm>"
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
    spdlog_1_11
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
