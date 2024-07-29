{
  cmake,
  fetchFromGitHub,
  lib,
  libsForQt5,
  pkg-config,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-tutorial";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp_tutorial";
    rev = "v${version}";
    hash = "sha256-h42aEpHlFZ5+Sh7s2jbwB+3APMAhVhyLHKnG7PYmjeI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [ libsForQt5.qtbase ];
  propagatedBuildInputs = [
    python3Packages.hpp-gepetto-viewer
    python3Packages.hpp-manipulation-corba
  ];

  doCheck = true;

  meta = {
    description = "Tutorial for humanoid path planner platform";
    homepage = "https://github.com/humanoid-path-planner/hpp_tutorial";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
