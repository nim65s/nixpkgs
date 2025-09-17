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
    (fetchpatch {
      url = "https://github.com/nim65s/vcglib/commit/3350032c99bbf7c0bc966ba90b39f1129317c37a.patch";
      hash = "sha256-F5RMIIhAQDqfE9gosqR+Z98ujGHAz/WpOfoGvgdIEb4=";
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
