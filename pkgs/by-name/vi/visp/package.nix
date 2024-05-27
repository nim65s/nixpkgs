# TODO:
# visp> In file included from /nix/store/g6lpg2p890jn3hkv63jjkk2f7k66y6hk-ogre-14.2.5/include/OGRE/Ogre.h:52,
# visp>                  from /build/source/modules/ar/include/visp3/ar/vpAROgre.h:66:
# visp> /nix/store/g6lpg2p890jn3hkv63jjkk2f7k66y6hk-ogre-14.2.5/include/OGRE/OgreConfigFile.h:94:41: note: declared here
# visp>    94 |         OGRE_DEPRECATED SectionIterator getSectionIterator(void);
# visp>       |                                         ^~~~~~~~~~~~~~~~~~
# visp> /build/source/modules/ar/src/ogre-simulator/vpAROgre.cpp:315:33: error: no matching function for call to 'Ogre::Root::showConfigDialog()'
# visp>   315 |     if (!mRoot->showConfigDialog()) {
# visp>       |          ~~~~~~~~~~~~~~~~~~~~~~~^~
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  eigen,
  opencv,
  lapack,
  libX11,
  #ogre,
  openblas,
  v4l-utils,
  zbar,
  xorg,
  libdc1394,
  libglvnd,
  libxml2,
  libpng,
  nlohmann_json,
  python3,
  zlib,
  coin3d,
  texliveSmall,
  libdmtx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "visp";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "lagadic";
    repo = "visp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m5Tmr+cZab7eSjmbXb8HpJpFHb0UYFTyimY+CkfBIAo=";
  };

  postPatch = ''
    # CMAKE_INSTALL_LIBDIR is expected to be either 'lib' or 'lib/x86_64-linux-gnu' here,
    # and we provide absolute path, so workaround some path computation
    substituteInPlace cmake/VISPGenerateConfig.cmake --replace-warn \
      'get_path_to_parent(''${VISP_LIB_INSTALL_PATH} VISP_INSTALL_LIBDIR_TO_PARENT)' 'set(VISP_INSTALL_LIBDIR_TO_PARENT "../")'
    # visp.pc.in expect relative paths, and we provide absolute: so no need to prepend prefix.
    substituteInPlace cmake/VISPGenerateConfigScript.cmake --replace-warn '\''${prefix}/' ""
    substituteInPlace cmake/VISPGenerateConfigScript.cmake --replace-warn '\''${exec_prefix}/' ""
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    texliveSmall
  ];

  doCheck = true;

  buildInputs = [
    coin3d
    eigen
    lapack
    libdmtx
    libxml2
    libdc1394
    libX11
    libglvnd
    libpng
    nlohmann_json
    #ogre
    openblas
    opencv
    (python3.withPackages(p: [p.numpy]))
    v4l-utils
    xorg.libpthreadstubs
    zbar
    zlib
  ];

  meta = {
    description = "Open Source Visual Servoing Platform";
    homepage = "https://visp.inria.fr";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
