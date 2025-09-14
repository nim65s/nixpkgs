{
  cmake,
  fetchFromGitHub,
  lib,
  libsForQt5,
  openscenegraph,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osgQt";
  version = "3.5.7-unstable-2021-04-05";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "osgQt";
    rev = "8fa9e2aed141488fa0818219f29e7ee9c7e667b0";
    hash = "sha256-i6/6jOK7goIYKxKe0dtUa4dE4nLcYzFy2k+qKMiYMzk=";
  };

  buildInputs = [ libsForQt5.qtbase ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [ openscenegraph ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DDESIRED_QT_VERSION=5"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  meta = {
    description = "Qt bindings for OpenSceneGraph";
    homepage = "https://github.com/openscenegraph/osgQt";
    license = "OpenSceneGraph Public License - free LGPL-based license";
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
