{
  boost,
  cmake,
  cxxopts,
  eigen,
  fetchFromGitHub,
  glew,
  gtest,
  lib,
  libsForQt5,
  libGL,
  metis,
  stdenv,
  tinyxml-2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sofa";
  version = "24.06.00";

  src = fetchFromGitHub {
    owner = "sofa-framework";
    repo = "sofa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X6HdyKqJvuyWIE4PnmlAODE8RVQJmEAHZ74ixp8+f18=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    boost
    cxxopts
    eigen
    glew
    gtest
    libGL
    metis
    tinyxml-2
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "SOFA_ALLOW_FETCH_DEPENDENCIES" false)
  ];

  doCheck = true;

  meta = {
    description = "Real-time multi-physics simulation with an emphasis on medical simulation";
    homepage = "https://github.com/sofa-framework/sofa";
    changelog = "https://github.com/sofa-framework/sofa/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "runSofa";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
