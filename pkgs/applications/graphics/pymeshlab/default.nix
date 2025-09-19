{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  python3Packages,

  # propagatedBuildInputs
  meshlab,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pymeshlab";
  version = "2025.7";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "pymeshlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LCR2/AyX9uVX4xhZareUL6YlpUsCFiGDMBB5nFp+H6k=";
  };

  patches = [
    # CMake: Allow use of our meshlab
    ./cmake.patch
  ];

  nativeBuildInputs = [
    cmake
    python3Packages.pybind11
  ];

  propagatedBuildInputs = [
    meshlab
    python3Packages.numpy
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${python3Packages.python.sitePackages}/pymeshlab"
  ];

  meta = {
    description = "Open source mesh processing python library";
    homepage = "https://github.com/cnr-isti-vclab/PyMeshLab";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = with lib.platforms; linux;
  };
})
