{
  lib,
  stdenv,

  fetchFromGitHub,
  nix-update-script,

  cmake,

  withShared ? (!stdenv.hostPlatform.isStatic),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpoases";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "qpOASES";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-L6uBRXaPJZinIRTm+x+wnXmlVkSlWm4XMB5yX/wxg2A=";
  };

  # ref. https://github.com/coin-or/qpOASES/pull/153
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.6)" \
      "cmake_minimum_required(VERSION 3.18)"
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" withShared)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "releases/(.*)"
    ];
  };

  meta = with lib; {
    description = "Open-source C++ implementation of the recently proposed online active set strategy";
    homepage = "https://github.com/coin-or/qpOASES";
    changelog = "https://github.com/coin-or/qpOASES/blob/${finalAttrs.src.tag}/VERSIONS.txt";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nim65s ];
  };
})
