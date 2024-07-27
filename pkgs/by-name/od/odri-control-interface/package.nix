{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  jrl-cmakemodules,
  odri-master-board-sdk,
  pythonSupport ? false,
  python3Packages,
  yaml-cpp,
}:

stdenv.mkDerivation rec {
  pname = "odri-control-interface";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "open-dynamic-robot-initiative";
    repo = "odri_control_interface";
    rev = "v${version}";
    hash = "sha256-NGsgrSyhD2fFTm/IqgdqXw7aMEwD7QSsPDhjDm+50qQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs =
    [
      jrl-cmakemodules
      eigen
      yaml-cpp
    ]
    ++ lib.optionals (!pythonSupport) [ odri-master-board-sdk ]
    ++ lib.optionals pythonSupport [
      python3Packages.eigenpy
      python3Packages.odri-master-board-sdk
    ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport) ];

  doCheck = true;

  meta = {
    description = "Low level control interface for ODRI robots";
    homepage = "https://github.com/open-dynamic-robot-initiative/odri_control_interface";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
