{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libsForQt5,
  libGLU,
  lib3ds,
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
  breakpointHook,
}:

let
  tinygltf-src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    rev = "v2.6.3";
    hash = "sha256-IyezvHzgLRyc3z8HdNsQMqDEhP+Ytw0stFNak3C8lTo=";
  };
in
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
    # breakpointHook
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
  ''
  + lib.optionalString false ''
    substituteInPlace src/external/tinygltf.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/tinygltf-2.6.3 ${tinygltf-src}
    substituteInPlace src/external/libigl.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/libigl-2.4.0 ${libigl}
    substituteInPlace src/external/nexus.cmake \
      --replace-fail '$'{NEXUS_DIR}/src/corto ${corto.src}
    substituteInPlace src/external/levmar.cmake \
      --replace-fail '$'{LEVMAR_LINK} ${levmar.src} \
      --replace-warn "MD5 ''${LEVMAR_MD5}" ""
    substituteInPlace src/external/ssynth.cmake \
      --replace-fail '$'{SSYNTH_LINK} ${structuresynth.src} \
      --replace-warn "MD5 ''${SSYNTH_MD5}" ""
    substituteInPlace src/common_gui/CMakeLists.txt \
      --replace-warn "MESHLAB_LIB_INSTALL_DIR" "CMAKE_INSTALL_LIBDIR"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "VCGDIR" "${vcg.src}")
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_BOOST" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_CGAL" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_EMBREE" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_LEVMAR" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_LIB3DS" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_LIB3MF" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_LIBIGL" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_MUPARSER" false)
    (lib.cmakeBool "MESHLAB_ALLOW_DOWNLOAD_SOURCE_NEXUS" false)
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
