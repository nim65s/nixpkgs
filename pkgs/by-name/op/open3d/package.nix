{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  python3,
  assimp,
  nanoflann,
  glfw,
  jsoncpp,
  git,
  eigen,
  withExamples ? false,
  withCuda ? false,
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

  cmakeFlags = [
    (lib.cmakeBool "BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "BUILD_CUDA_MODULE" withCuda)
    (lib.cmakeBool "BUILD_GUI" withGui)
    (lib.cmakeBool "BUILD_WEBRTC" withGui)
    (lib.cmakeBool "BUILD_JUPYTER_EXTENSION" withGui)
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_UNIT_TESTS=ON"
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
    # TODO
    "-DBUILD_ISPC_MODULE=OFF"
  ];

  nativeBuildInputs = [
    cmake
    git
  ];

  buildInputs = [
    python3
    assimp
    glfw
    jsoncpp
  ];

  propagatedBuildInputs = [
    eigen
    nanoflann
  ];

  meta = {
    changelog = "https://github.com/isl-org/Open3D/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "A Modern Library for 3D Data Processing";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
