{
  cmake,
  fetchFromGitHub,
  lib,
  libsForQt5,
  pkg-config,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-gepetto-viewer";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gepetto-viewer";
    rev = "v${version}";
    hash = "sha256-HxQlm5TA0c9ureS93a5mVAWJN9t3K/LAHGF2pmutzUo=";
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
    python3Packages.hpp-corbaserver
  ];

  doCheck = true;

  #pythonImportsCheck = [ "hpp.gepetto" ];

  meta = {
    description = "Display of hpp robots and obstacles in gepetto-viewer";
    homepage = "https://github.com/humanoid-path-planner/hpp-gepetto-viewer";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
