{
  assimp,
  blas,
  boost,
  civetweb,
  cmake,
  cudaPackages,
  curl,
  directx-headers,
  eigen,
  embree,
  fetchFromGitHub,
  fetchpatch,
  fetchzip,
  filament,
  fmt,
  git,
  glew,
  glfw,
  gtest,
  imgui,
  ispc,
  jsoncpp,
  lapack,
  lib,
  libGL,
  libjpeg,
  liblzf,
  libpng,
  librealsense,
  msgpack,
  msgpack-cxx,
  nanoflann,
  onedpl,
  opensycl,
  pkg-config,
  #poisson-recon,
  python3Packages,
  qhull,
  stdenv,
  tbb,
  tinygltf,
  tinyobjloader,
  uvatlas,
  vtk,
  withExamples ? true,
  withCuda ? false,
  withPython ? true,
  withGui ? true,
  zeromq,
  zlib,
}:

let
  # their fork does not have the same headers as upstream
  poisson-recon = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D-PoissonRecon";
    rev = "90f3f064e275b275cff445881ecee5a7c495c9e0";
    hash = "sha256-0cHy3KxvhiJxVrVh/j1FcFMy60o5mQedIapZrOjKhQo=";
  };

  # I have no idea how to properly package that
  webrtc = fetchzip {
    url = "https://github.com/isl-org/open3d_downloads/releases/download/webrtc-v3/webrtc_60e6748_cxx-abi-1.tar.gz";
    hash = "sha256-1RMHy1qZYt13b6PiuU+wYEmeIesmWENRVmm7y3V0eFU=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "open3d";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VMykWYfWUzhG+Db1I/9D1GTKd3OzmSXvwzXwaZnu8uI=";
  };

  # Teach CMake how to find our liblzf, tinygltf & filament
  patches = [
    (fetchpatch {
      url = "https://github.com/nim65s/Open3D/commit/9537de0889e07bb94d3ddb6b0313d555595e44c8.patch";
      hash = "sha256-pDplNXCuEd1yxLNA18sXh5G8GyZWaj6dhjM6pwN8RFI=";
    })
    (fetchpatch {
      url = "https://github.com/nim65s/Open3D/commit/d5f8b1c9.patch";
      hash = "sha256-bcH02febrpyNRyX9DX3qEzFk9Qf384cw9NAXU7fDSuo=";
    })
    (fetchpatch {
      url = "https://github.com/nim65s/Open3D/commit/940cda4b.patch";
      hash = "sha256-csbYnVRCVQT5AOn6480iEor42VuJplb1tEJEuL3nV7w=";
    })
  ];

  postPatch = ''
    # avoid fetch FetchContent on
    # https://github.com/isl-org/open3d_downloads/releases/download/mesa-libgl/mesa_libGL_22.1.4.tar.bz2
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "if(BUILD_GUI AND UNIX AND NOT APPLE)" \
      "if(BUILD_GUI AND UNIX AND NOT APPLE)
         set(MESA_CPU_GL_LIBRARY ${lib.getLib libGL}/lib/libGL.so)
       else()"

    # avoid fetch ISPC
    substituteInPlace CMakeLists.txt --replace-fail \
        'open3d_fetch_ispc_compiler()' \
      'set(CMAKE_ISPC_COMPILER "${lib.getExe ispc}")'

    # fetch PoissonRecon ourself
    substituteInPlace 3rdparty/possionrecon/possionrecon.cmake --replace-fail \
      "URL https://github.com/isl-org/Open3D-PoissonRecon/archive/90f3f064e275b275cff445881ecee5a7c495c9e0.tar.gz" \
      "URL ${poisson-recon}"

    # fetch webrtc ourself
    substituteInPlace 3rdparty/webrtc/webrtc_download.cmake --replace-fail \
      "URL \$""{WEBRTC_URL}" \
      "URL ${webrtc}"

    # avoid fetch civetweb
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "include(\$""{Open3D_3RDPARTY_DIR}/civetweb/civetweb.cmake)
        open3d_import_3rdparty_library(3rdparty_civetweb
            INCLUDE_DIRS \$""{CIVETWEB_INCLUDE_DIRS}
            LIB_DIR      \$""{CIVETWEB_LIB_DIR}
            LIBRARIES    \$""{CIVETWEB_LIBRARIES}
            DEPENDS      ext_civetweb
        )" \
      "find_package(civetweb CONFIG REQUIRED)
       open3d_import_3rdparty_library(3rdparty_civetweb DEPENDS civetweb::civetweb-cpp)"

    # avoid fetch onedpl
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "include(\$""{Open3D_3RDPARTY_DIR}/parallelstl/parallelstl.cmake)
        open3d_import_3rdparty_library(3rdparty_parallelstl
        PUBLIC
        INCLUDE_DIRS \$""{PARALLELSTL_INCLUDE_DIRS}
        INCLUDE_ALL
        DEPENDS      ext_parallelstl
        )
        list(APPEND Open3D_3RDPARTY_PUBLIC_TARGETS_FROM_SYSTEM Open3D::3rdparty_parallelstl)" \
      "find_package(oneDPL CONFIG REQUIRED)
       open3d_import_3rdparty_library(3rdparty_parallelstl DEPENDS oneDPL)"
  '';

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];
  buildInputs = [
    assimp
    blas
    boost
    civetweb
    curl
    directx-headers
    directx-math:
    eigen
    embree
    filament
    fmt
    glew
    glfw
    gtest
    imgui
    ispc
    jsoncpp
    lapack
    libGL
    libjpeg
    liblzf
    libpng
    librealsense
    msgpack
    msgpack-cxx
    nanoflann
    onedpl
    opensycl
    poisson-recon
    qhull
    tbb
    tinygltf
    tinyobjloader
    uvatlas
    vtk
    zeromq
    zlib
  ] ++ lib.optionals withCuda [
    cudaPackages.cuda_nvcc
  ] ++ lib.optionals withPython [
    python3Packages.pybind11
    python3Packages.python
    python3Packages.torch
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CUDA_MODULE" withCuda)
    (lib.cmakeBool "BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "BUILD_PYTHON_MODULE" withPython)
    (lib.cmakeBool "BUILD_GUI" withGui)
    (lib.cmakeBool "ENABLE_HEADLESS_RENDERING" (!withGui))
    (lib.cmakeBool "BUILD_WEBRTC" withGui)
    (lib.cmakeBool "BUILD_JUPYTER_EXTENSION" (withGui && withPython))
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "BUILD_SYCLE_MODULE" true)
    (lib.cmakeBool "BUILD_UNIT_TESTS" true)
    (lib.cmakeBool "USE_BLAS" true)
    (lib.cmakeBool "USE_SYSTEM_BLAS" true)
    (lib.cmakeBool "USE_SYSTEM_ASSIMP" true)
    (lib.cmakeBool "USE_SYSTEM_CURL" true)
    (lib.cmakeBool "USE_SYSTEM_CUTLASS" true)
    (lib.cmakeBool "USE_SYSTEM_EIGEN3" true)
    (lib.cmakeBool "USE_SYSTEM_EMBREE" true)
    (lib.cmakeBool "USE_SYSTEM_FILAMENT" true)
    (lib.cmakeBool "USE_SYSTEM_FMT" true)
    (lib.cmakeBool "USE_SYSTEM_GLEW" true)
    (lib.cmakeBool "USE_SYSTEM_GLFW" true)
    (lib.cmakeBool "USE_SYSTEM_GOOGLETEST" true)
    (lib.cmakeBool "USE_SYSTEM_IMGUI" true)
    (lib.cmakeBool "USE_SYSTEM_JPEG" true)
    (lib.cmakeBool "USE_SYSTEM_JSONCPP" true)
    (lib.cmakeBool "USE_SYSTEM_LIBLZF" true)
    (lib.cmakeBool "USE_SYSTEM_MSGPACK" true)
    (lib.cmakeBool "USE_SYSTEM_NANOFLANN" true)
    (lib.cmakeBool "USE_SYSTEM_OPENSSL" true)
    (lib.cmakeBool "USE_SYSTEM_PNG" true)
    (lib.cmakeBool "USE_SYSTEM_PYBIND11" withPython)
    (lib.cmakeBool "USE_SYSTEM_QHULLCPP" true)
    (lib.cmakeBool "USE_SYSTEM_STDGPU" true)
    (lib.cmakeBool "USE_SYSTEM_TBB" true)
    (lib.cmakeBool "USE_SYSTEM_TINYGLTF" true)
    (lib.cmakeBool "USE_SYSTEM_TINYOBJLOADER" true)
    (lib.cmakeBool "USE_SYSTEM_VTK" true)
    (lib.cmakeBool "USE_SYSTEM_ZEROMQ" true)
    (lib.cmakeBool "BUILD_LIBREALSENSE" true)
    (lib.cmakeBool "USE_SYSTEM_LIBREALSENSE" true)
    (lib.cmakeBool "BUILD_TENSORFLOW_OPS" false)  # TODO: Is this a nightmare ?
    (lib.cmakeBool "BUILD_PYTORCH_OPS" withPython)
    (lib.cmakeBool "BUILD_VTK_FROM_SOURCE" false)
    (lib.cmakeBool "BUILD_FILAMENT_FROM_SOURCE" false)
    (lib.cmakeBool "PREFER_OSX_HOMEBREW" false)
    (lib.cmakeBool "BUILD_ISPC_MODULE" true)
    (lib.cmakeBool "WITH_IPPICV" false)
  ];

  meta = {
    description = "Modern Library for 3D Data Processing";
    homepage = "https://github.com/isl-org/Open3D";
    changelog = "https://github.com/isl-org/Open3D/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
