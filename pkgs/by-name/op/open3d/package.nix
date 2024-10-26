{
  assimp,
  blas,
  boost,
  civetweb,
  cmake,
  cppzmq,
  cudaPackages,
  curl,
  directx-headers,
  directx-math,
  eigen,
  embree,
  fetchFromGitHub,
  fetchpatch,
  fetchzip,
  filament,
  fmt_9,
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
  llvmPackages,
  minizip,
  msgpack,
  msgpack-cxx,
  nanoflann,
  oneDPL,
  opensycl,
  pkg-config,
  #poisson-recon,
  python3Packages,
  qhull,
  salh,
  clangStdenv,
  spectra,
  tbb,
  tinygltf,
  tinyobjloader,
  uvatlas,
  vtk,
  withExamples ? true,
  withCuda ? false,
  withPython ? true,
  withGui ? true,
  xorg,
  zeromq,
  zlib,
}:

let
  # their fork does not have the same headers as upstream
  poisson-recon-fork = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D-PoissonRecon";
    rev = "90f3f064e275b275cff445881ecee5a7c495c9e0";
    hash = "sha256-0cHy3KxvhiJxVrVh/j1FcFMy60o5mQedIapZrOjKhQo=";
  };

  # I have no idea how to properly package that
  webrtc-fork = fetchzip {
    url = "https://github.com/isl-org/open3d_downloads/releases/download/webrtc-v3/webrtc_60e6748_cxx-abi-1.tar.gz";
    hash = "sha256-1RMHy1qZYt13b6PiuU+wYEmeIesmWENRVmm7y3V0eFU=";
  };

  # TODO: dig why they need a fork
  filament-fork = fetchzip {
    url = "https://github.com/isl-org/filament/archive/d1d873d27f43ba0cee1674a555cc0f18daac3008.tar.gz";
    hash = "sha256-RN+51ODInmjrfHYbLATjF2iB2HGFxfzlH+VCSAyB2TU";
  };
in

clangStdenv.mkDerivation (finalAttrs: {
  pname = "open3d";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VMykWYfWUzhG+Db1I/9D1GTKd3OzmSXvwzXwaZnu8uI=";
  };

  patches = [
    # Teach CMake how to find our liblzf, tinygltf & filament
    (fetchpatch {
      url = "https://github.com/nim65s/Open3D/commit/9537de0889e07bb94d3ddb6b0313d555595e44c8.patch";
      hash = "sha256-pDplNXCuEd1yxLNA18sXh5G8GyZWaj6dhjM6pwN8RFI=";
    })
    (fetchpatch {
      url = "https://github.com/nim65s/Open3D/commit/d5f8b1c9.patch";
      hash = "sha256-bcH02febrpyNRyX9DX3qEzFk9Qf384cw9NAXU7fDSuo=";
    })
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/940cda4b.patch";
      #hash = "sha256-csbYnVRCVQT5AOn6480iEor42VuJplb1tEJEuL3nV7w=";
    #})
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/d6231ab0.patch";
      #hash = "sha256-TDLa3+7isgGz8p5nTMLfJ6Nf44vke5bHygk82ON2XxI=";
    #})
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/470201de.patch";
      #hash = "sha256-8dPE9xSZLRMxJN27i0C/Gozb2TKuBr1zW4VrVbEvUFw=";
    #})

    # Allow use of embree >= 4
    (fetchpatch {
      url = "https://github.com/isl-org/Open3D/pull/6665/commits/43e7ceb8e676dfe812c52362d18d716041cc239d.patch";
      hash = "sha256-93j6QYo4c0CKY4KnVP5OEvTw+/jVNf7FKTfSsrGldDE=";
    })
    (fetchpatch {
      url = "https://github.com/isl-org/Open3D/pull/6665/commits/94e64ae7f11a6ecb1aa8d1c06eb57ad26c18e3d6.patch";
      hash = "sha256-ud9RnGrNud+DrPTB8eCHRu3KeAAxOlHrQhw9YAs81wE=";
    })

    # Allow use of imgui >= 1.89.6
    (fetchpatch {
      url = "https://github.com/nim65s/Open3D/commit/6c052b846dce28a0015246c63efea5f706b3286b.patch";
      hash = "sha256-a5wd9ALeqwpfUrgBwI1u/HnWTK3MnPXat2If3v2+dM8=";
    })

    # Allow use of filament >= 1.25.6 (Camera: float -> double)
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/145b934b0c2165189f7ea68dd15f59b574afebcd.patch";
      #hash = "sha256-g5N+/mnNwOFoy837XBB9peiEIRE/5293CPGujOirenU=";
    #})

    ## Allow use of filament >= 1.12.1 (Camera: float -> double)
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/85f022ca.patch";
      #hash = "sha256-gvVSM+bW9JESxhKIaiFDTTpkl+Tf9wENVn8496nFUic=";
    #})

    ## Allow use of filament >= 1.12.1 (Ktx -> Ktx1)
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/8be0e960.patch";
      #hash = "sha256-ah8gtLOWCSIuvBgE5cJWxKURTZc3Y7frsHmDwMVujDY=";
    #})

    ## Allow use of filament >= 1.9.24 (uchimura / reinhard removed)
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/ee088905.patch";
      #hash = "sha256-DhN4pTTSB1ZAKSsmhSLi4txmJLaRCjqwxuMptLbqTCI=";
    #})

    ## Allow use of filament >= 1.23.1 (setGeometryAt
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/59759786.patch";
      #hash = "sha256-NVlsDXf+U5zfja5gWMxSaX6QN20BEuhhyvXHeK0Nx90=";
    #})
    #(fetchpatch {
      #url = "https://github.com/nim65s/Open3D/commit/64701620.patch";
      #hash = "sha256-qWEmq67npveDFBAK/GYa6853w7v/Q3IxAZnYNyvXpaI=";
    #})

    # Add missing includes
    (fetchpatch {
      url = "https://github.com/isl-org/Open3D/pull/6847/commits/dcea5f9ce122317f2289e1b682d9d5567564275d.patch";
      hash = "sha256-8imKdU8miIMPfFVCsDU3QsV2r/+GVQG1d8ewGb20lS4";
    })

  ];

  postPatch = ''
    # avoid fetch mesa
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
      "URL ${poisson-recon-fork}"

    # fetch webrtc ourself
    substituteInPlace 3rdparty/webrtc/webrtc_download.cmake --replace-fail \
      "URL \$""{WEBRTC_URL}" \
      "URL ${webrtc-fork}"

    substituteInPlace 3rdparty/filament/filament_build.cmake --replace-fail \
      "URL https://github.com/isl-org/filament/archive/d1d873d27f43ba0cee1674a555cc0f18daac3008.tar.gz" \
      "URL ${filament-fork}"

    # avoid fetch civetweb
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "include(\$""{Open3D_3RDPARTY_DIR}/civetweb/civetweb.cmake)
        open3d_import_3rdparty_library(3rdparty_civetweb
            INCLUDE_DIRS \$""{CIVETWEB_INCLUDE_DIRS}
            LIB_DIR      \$""{CIVETWEB_LIB_DIR}
            LIBRARIES    \$""{CIVETWEB_LIBRARIES}
            DEPENDS      ext_civetweb
        )" \
      "open3d_find_package_3rdparty_library(3rdparty_civetweb
         PACKAGE civetweb
         TARGETS civetweb::civetweb-cpp)"

    # avoid fetch oneDPL
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "include(\$""{Open3D_3RDPARTY_DIR}/parallelstl/parallelstl.cmake)
        open3d_import_3rdparty_library(3rdparty_parallelstl
        PUBLIC
        INCLUDE_DIRS \$""{PARALLELSTL_INCLUDE_DIRS}
        INCLUDE_ALL
        DEPENDS      ext_parallelstl
        )
        list(APPEND Open3D_3RDPARTY_PUBLIC_TARGETS_FROM_SYSTEM Open3D::3rdparty_parallelstl)" \
      "open3d_find_package_3rdparty_library(3rdparty_parallelstl
         PACKAGE oneDPL
         INCLUDE_DIRS ${oneDPL}/include/oneapi/dpl
         TARGETS oneDPL)"

    # avoid fetch uvatlas
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "include(\$""{Open3D_3RDPARTY_DIR}/uvatlas/uvatlas.cmake)
    open3d_import_3rdparty_library(3rdparty_uvatlas
        HIDDEN
        INCLUDE_DIRS \$""{UVATLAS_INCLUDE_DIRS}
        LIB_DIR      \$""{UVATLAS_LIB_DIR}
        LIBRARIES    \$""{UVATLAS_LIBRARIES}
        DEPENDS      ext_uvatlas
    )" \
      "open3d_find_package_3rdparty_library(3rdparty_uvatlas
         PACKAGE UVAtlas
         TARGETS Microsoft::UVAtlas)"

    # Fix hardcoded matc bin path from filament
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "/usr/bin/matc" \
      "${lib.getExe' filament "matc"}"

    # utility wants unzip.h
    echo "target_include_directories(utility PRIVATE
      ${minizip}/include/minizip
      )" >> cpp/open3d/utility/CMakeLists.txt

    # tgeometry_kernel wants unknwn.h & DirectXMath.h
    #echo "target_include_directories(tgeometry_kernel PRIVATE
      #${directx-headers}/include/wsl/stubs
      #${directx-math}/include/directxmath
      #)" >> cpp/open3d/t/geometry/kernel/CMakeLists.txt

    # partial replace onedpl with tbb, because "fatal error: pstl/execution: No such file or directory"
    # ref. https://github.com/isl-org/Open3D/pull/6809
    substituteInPlace cpp/open3d/utility/ParallelScan.h --replace-fail \
      "TBB_INTERFACE_VERSION >= 10000" \
      "false"

    # fix lzf includes
    substituteInPlace cpp/open3d/io/file_format/FilePCD.cpp --replace-fail \
      "liblzf/lzf.h" \
      "lzf.h"
    substituteInPlace cpp/open3d/t/io/file_format/FilePCD.cpp --replace-fail \
      "liblzf/lzf.h" \
      "lzf.h"

    # C++17 is required by filament and its "is_same_v"
    substituteInPlace CMakeLists.txt --replace-fail \
      "CMAKE_CXX_STANDARD 14" \
      "CMAKE_CXX_STANDARD 17" \

    # don't abort compilation for an unused or deprecated stuff
    echo 'set_target_properties(visualization PROPERTIES
      COMPILE_FLAGS "-Wno-unused-function -Wno-deprecated-declarations"
      )' >> cpp/open3d/visualization/CMakeLists.txt

    # Fix -Wpessimizing-move-Werror
    substituteInPlace cpp/open3d/visualization/rendering/RendererHandle.h --replace-fail \
      "return std::move(REHandle(id));" \
      "return REHandle(id);"
    substituteInPlace cpp/open3d/visualization/rendering/filament/FilamentResourceManager.cpp --replace-fail \
      "return std::move(std::shared_ptr<ResourceType>(
                pointer, [&engine](ResourceType* p) { engine.destroy(p); }));" \
      "return std::shared_ptr<ResourceType>(
                pointer, [&engine](ResourceType* p) { engine.destroy(p); });"


    # wtf
    #substituteInPlace cpp/open3d/visualization/rendering/filament/FilamentResourceManager.cpp \
      #--replace-fail \
        #"RenderTarget::COLOR" \
        #"RenderTarget::AttachmentPoint::COLOR" \
      #--replace-fail \
        #"RenderTarget::DEPTH" \
        #"RenderTarget::AttachmentPoint::DEPTH"

    # don't hardcode clang things
    substituteInPlace 3rdparty/find_dependencies.cmake --replace-fail \
      "set(CLANG_LIBDIR \"/usr/lib/llvm-\$""{CMAKE_MATCH_1}/lib\")" \
      "set(CLANG_LIBDIR \"${lib.getLib llvmPackages.libcxx}/lib\")"
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
    cppzmq
    curl
    directx-headers
    directx-math
    eigen
    embree
    filament
    fmt_9
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
    llvmPackages.libcxx
    llvmPackages.openmp
    minizip
    msgpack
    msgpack-cxx
    nanoflann
    oneDPL
    opensycl
    #poisson-recon
    qhull
    salh
    spectra
    tbb
    tinygltf
    tinyobjloader
    uvatlas
    vtk
    xorg.libXrandr
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
    (lib.cmakeBool "USE_SYSTEM_FILAMENT" false)  # too hard for now
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
    (lib.cmakeBool "BUILD_TENSORFLOW_OPS" false)
    (lib.cmakeBool "BUILD_PYTORCH_OPS" withPython)
    (lib.cmakeBool "BUILD_VTK_FROM_SOURCE" false)
    (lib.cmakeBool "BUILD_FILAMENT_FROM_SOURCE" true)  # TODO
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
