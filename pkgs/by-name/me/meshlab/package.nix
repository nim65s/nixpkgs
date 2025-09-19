{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libsForQt5,
  libGLU,
  lib3ds,
  lib3mf,
  bzip2,
  muparser,
  eigen,
  glew,
  gmp,
  levmar,
  qhull,
  cmake,
  cgal,
  boost,
  mpfr,
  xercesc,
  tbb,
  embree,
  vcg,
  libigl,
  corto,
  openctm,
  structuresynth,
  vclab-nexus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meshlab";
  version = "2025.07";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    rev = "MeshLab-${finalAttrs.version}";
    hash = "sha256-6BozYzPCbBZ+btL4FCdzKlwKqTsvFWDfOXizzJSYo9s=";
  };

  buildInputs = [
    libGLU
    libsForQt5.qtbase
    libsForQt5.qtscript
    libsForQt5.qtxmlpatterns
    lib3ds
    lib3mf
    bzip2
    muparser
    eigen
    glew
    gmp
    levmar
    qhull
    cgal
    boost
    mpfr
    xercesc
    tbb
    embree
    vcg
    libigl
    corto
    openctm
    structuresynth
    vclab-nexus
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  patches = [
    # Allow use of system levmar
    ./cmake.patch
  ];

  preConfigure = ''
    substituteAll ${./meshlab.desktop} resources/linux/meshlab.desktop
  '';

  postFixup = ''
    patchelf \
      --add-needed $out/lib/meshlab/libmeshlab-common.so \
      --add-needed $out/lib/meshlab/libmeshlab-common-gui.so \
      $out/bin/.meshlab-wrapped
  '';

  # display a black screen on wayland, so force XWayland for now.
  # Might be fixed when upstream will be ready for Qt6.
  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = {
    description = "System for processing and editing 3D triangular meshes";
    mainProgram = "meshlab";
    homepage = "https://www.meshlab.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = with lib.platforms; linux;
  };
})
