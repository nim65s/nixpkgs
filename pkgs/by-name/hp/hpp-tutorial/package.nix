{
  cmake,
  doxygen,
  fetchFromGitHub,
  lib,
  libsForQt5,
  pkg-config,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-tutorial";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp_tutorial";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mo9+IYlEDMSOi7fDyA6yb8ZdACBBy2uNCzR//icMCmg=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
    python3Packages.python
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
    changelog = "https://github.com/humanoid-path-planner/hpp_tutorial/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
