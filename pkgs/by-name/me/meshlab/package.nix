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
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  patches = [
    # Allow use of system levmar
    (fetchpatch {
      url = "https://github.com/nim65s/meshlab/commit/ce1e2d3eb2dcf2dd9daec79ced7d918c8aed08c5.patch";
      hash = "sha256-oat1vN3ObNXl7xEOYtgEvIO3drFtp1T/UbPcrAJhoxY=";
    })
    # Allow use of system lib3mf
    (fetchpatch {
      url = "https://github.com/nim65s/meshlab/commit/393df66ed5334983379ddbedcaee5bfc57daf0f8.patch";
      hash = "sha256-vzhBhFbE5h1OfCW/3ZDSBnyFVfgvd3NbJ9+v52M/h5o=";
    })
    # Allow use of system libigl
    (fetchpatch {
      url = "https://github.com/nim65s/meshlab/commit/80ad48ffb.patch";
      hash = "sha256-StBjRDFdPvI5cXL4wKaGQAFnKzHjdPb9RS3WbkAni60=";
    })
  ];

  preConfigure = ''
    substituteAll ${./meshlab.desktop} resources/linux/meshlab.desktop
  '';

  cmakeFlags = [
    (lib.cmakeFeature "VCGDIR" "${vcg.src}")
  ];

  postFixup = ''
    patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlab-wrapped
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
