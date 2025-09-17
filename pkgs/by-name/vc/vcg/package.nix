{
  lib,

  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vcg";
  version = "2025.07";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "vcglib";
    tag = finalAttrs.version;
    hash = "sha256-OZnqFnHGXC9fS7JCLTiHNCeA//JBAZGLB5SP/rGzaA8=";
  };

  patches = [
    # Fix CMake packaging
    (fetchpatch {
      url = "https://github.com/nim65s/vcglib/commit/82c5c93c.patch";
      hash = "sha256-Q9oTPZ2PHBQf8W5KxC9wzCKAkQCswN2kNCxSL5eLmSQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [ eigen ];

  cmakeFlags = [
    (lib.cmakeBool "VCG_ALLOW_BUNDLED_EIGEN" false)
  ];

  meta = {
    homepage = "https://vcg.isti.cnr.it/vcglib/install.html";
    description = "C++ library for manipulation, processing and displaying with OpenGL of triangle and tetrahedral meshes";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
