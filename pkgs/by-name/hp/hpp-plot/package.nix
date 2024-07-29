{
  cmake,
  fetchFromGitHub,
  lib,
  libsForQt5,
  pkg-config,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-plot";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-plot";
    rev = "v${version}";
    hash = "sha256-1PAjJq1PbashQNqmoYLEZYDuEwGW0zInhyH66LqUSuM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [ libsForQt5.qtbase ];
  propagatedBuildInputs = [
    python3Packages.gepetto-viewer-corba
    python3Packages.hpp-manipulation-corba
  ];

  doCheck = true;

  meta = {
    description = "Graphical utilities for constraint graphs in hpp-manipulation";
    homepage = "https://github.com/humanoid-path-planner/hpp-plot";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
