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
      url = "https://github.com/nim65s/vcglib/commit/028e2bce71ca5bb820efa8e80c49fc24375524a2.patch";
      hash = "sha256-U29xbmUyKm+XOeQpAPSEiVIxRup+POI5u5oKd7RgHoM=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    eigen
  ];

  cmakeFlags = [
    (lib.cmakeBool "VCG_ALLOW_BUNDLED_EIGEN" false)
    (lib.cmakeBool "VCG_BUILD_EXAMPLES" false)
  ];

  meta = {
    homepage = "https://vcg.isti.cnr.it/vcglib/install.html";
    description = "C++ library for manipulation, processing and displaying with OpenGL of triangle and tetrahedral meshes";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
