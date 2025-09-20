{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  python3Packages,

  # propagatedBuildInputs
  meshlab,

  # buildInputs
  libsForQt5,
  glew,
  vcg,
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
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs = [
    glew
    libsForQt5.qtbase
    vcg
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${python3Packages.python.sitePackages}/pymeshlab"
  ];

  postFixup = ''
    patchelf \
      --add-needed ${meshlab}/lib/meshlab/libmeshlab-common.so \
      $out/${python3Packages.python.sitePackages}/pymeshlab/pmeshlab.*.so
  '';


  pythonImportsCheck = [ "pymeshlab" ];

  meta = {
    description = "Open source mesh processing python library";
    homepage = "https://github.com/cnr-isti-vclab/PyMeshLab";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = with lib.platforms; linux;
  };
})
