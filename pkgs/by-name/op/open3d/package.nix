{
  assimp,
  cmake,
  eigen,
  fetchFromGitHub,
  filament,
  fmt,
  git,
  glew,
  glfw,
  gtest,
  imgui,
  jsoncpp,
  lib,
  liblzf,
  libpng,
  nanoflann,
  python3Packages,
  qhull,
  stdenv,
  tinygltf,
  tinyobjloader,
  withExamples ? false,
  withCuda ? false,
  withPython ? false,
  withGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open3d";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VMykWYfWUzhG+Db1I/9D1GTKd3OzmSXvwzXwaZnu8uI=";
  };

  nativeBuildInputs = [
    cmake
    git
  ];
  buildInputs = [
    assimp
    eigen
    filament
    fmt
    glew
    glfw
    gtest
    imgui
    jsoncpp
    libpng
    liblzf
    nanoflann
    python3Packages.python
    qhull
    tinygltf
    tinyobjloader
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CUDA_MODULE" withCuda)
    (lib.cmakeBool "BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "BUILD_PYTHON_MODULE" withPython)
    (lib.cmakeBool "BUILD_GUI" withGui)
    (lib.cmakeBool "BUILD_WEBRTC" withGui)
    (lib.cmakeBool "BUILD_JUPYTER_EXTENSION" withGui)
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_UNIT_TESTS=ON"
    #"-DBUILD_ISPC_MODULE=OFF" # TODO: it really tries to fetch stuff
    #"-DENABLE_HEADLESS_RENDERING=ON" it is either that or GUI
    "-DUSE_SYSTEM_BLAS=ON"
    "-DUSE_SYSTEM_ASSIMP=ON"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_CUTLASS=ON"
    "-DUSE_SYSTEM_EIGEN3=ON"
    "-DUSE_SYSTEM_EMBREE=ON"
    "-DUSE_SYSTEM_FILAMENT=ON"
    "-DUSE_SYSTEM_FMT=ON"
    "-DUSE_SYSTEM_GLEW=ON"
    "-DUSE_SYSTEM_GLFW=ON"
    "-DUSE_SYSTEM_GOOGLETEST=ON"
    "-DUSE_SYSTEM_IMGUI=ON"
    "-DUSE_SYSTEM_JPEG=ON"
    "-DUSE_SYSTEM_JSONCPP=ON"
    "-DUSE_SYSTEM_LIBLZF=ON"
    "-DUSE_SYSTEM_MSGPACK=ON"
    "-DUSE_SYSTEM_NANOFLANN=ON"
    "-DUSE_SYSTEM_OPENSSL=ON"
    "-DUSE_SYSTEM_PNG=ON"
    "-DUSE_SYSTEM_PYBIND11=ON"
    "-DUSE_SYSTEM_QHULLCPP=ON"
    "-DUSE_SYSTEM_STDGPU=ON"
    "-DUSE_SYSTEM_TBB=ON"
    "-DUSE_SYSTEM_TINYGLTF=ON"
    "-DUSE_SYSTEM_TINYOBJLOADER=ON"
    "-DUSE_SYSTEM_VTK=ON"
    "-DUSE_SYSTEM_ZEROMQ=ON"
    "-DBUILD_LIBREALSENSE=ON"
    "-DUSE_SYSTEM_LIBREALSENSE=ON"
    "-DBUILD_TENSORFLOW_OPS=ON"
    "-DBUILD_PYTORCH_OPS=ON"
    "-DBUILD_VTK_FROM_SOURCE=OFF"
    "-DBUILD_FILAMENT_FROM_SOURCE=OFF"
    "-DPREFER_OSX_HOMEBREW=OFF"
    # TODO
    "-DBUILD_ISPC_MODULE=OFF"
  ];

  meta = {
    description = "Modern Library for 3D Data Processing";
    homepage = "https://github.com/isl-org/Open3D";
    changelog = "https://github.com/isl-org/Open3D/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
