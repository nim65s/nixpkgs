{
  cmake,
  fetchFromGitHub,
  lib,
  libsForQt5,
  pkg-config,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-gui";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gui";
    rev = "v${version}";
    hash = "sha256-kMROlXrZMv3c6e8vwS1h07HwJ3cY6ivrs5RkCUFGTtA=";
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
    description = "Qt based GUI for HPP project";
    homepage = "https://github.com/humanoid-path-planner/hpp-gui";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
