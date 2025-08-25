{
  lib,
  stdenv,

  fetchFromGitHub,
  libsForQt5,
  nix-update-script,

  # nativeBuildInputs
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,

  # buildInputs
  assimp,
  directx-shader-compiler,
  expat,
  gbenchmark,
  gtest,
  cityhash,
  libtiff,
  libunwind,
  lua54Packages,
  lz4,
  mcpp,
  openssl,
  rapidjson,
  rapidxml,
  spirv-cross,
  sqlite,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  vulkan-validation-layers,
  xxHash,
  zstd,
  zlib,

  # propagatedBuildInputs
  python3,
}:
let
  # cat python/requirements.txt | grep == | cut -d= -f1
  # + pybind11
  python = python3.withPackages (
    p: with p; [
      atomicwrites
      attrs
      boto3
      botocore
      certifi
      chardet
      charset-normalizer
      colorama
      docutils
      easyprocess
      exceptiongroup
      gitdb
      smmap
      gitpython
      idna
      imageio
      importlib-metadata
      jinja2
      jmespath
      markupsafe
      more-itertools
      numpy
      packaging
      pillow
      pluggy
      progressbar2
      psutil
      pybind11
      pyparsing
      pyscreenshot
      pytest-mock
      pytest-timeout
      pytest
      python-dateutil
      python-utils
      requests
      s3transfer
      scipy
      six
      urllib3
      wcwidth
      zipp
      tomli
      iniconfig
      toml
      resolvelib
      puremagic
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "o3de";
  version = "2505.1";

  src = fetchFromGitHub {
    owner = "o3de";
    repo = "o3de";
    tag = finalAttrs.version;
    hash = "sha256-L6nAX5+LzRsHVq9fpOKXgMkdI2ytVG3OVtQeACFz35M=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "include(CTest)" \
        "include(CTest)

         cmake_policy(SET CMP0175 OLD)

         find_package(assimp REQUIRED)
         find_package(benchmark REQUIRED)
         find_package(expat REQUIRED)
         find_package(GTest REQUIRED)
         find_package(Lua REQUIRED)
         find_package(lz4 REQUIRED)
         find_package(OpenSSL REQUIRED)
         find_package(Python REQUIRED)
         find_package(pybind11 REQUIRED)
         find_package(Qt5 REQUIRED COMPONENTS Concurrent Core Gui Network OpenGL Svg Test Widgets Xml)
         find_package(RapidJSON REQUIRED)
         find_package(spirv_cross_core REQUIRED)
         find_package(spirv_cross_glsl REQUIRED)
         find_package(spirv_cross_cpp REQUIRED)
         find_package(SQLite3 REQUIRED)
         find_package(Tiff REQUIRED)
         find_package(Vulkan REQUIRED COMPONENTS dxc)
         find_package(xxHash REQUIRED)
         find_package(ZLIB REQUIRED)

         # ref. https://cmake.org/cmake/help/latest/module/FindLua.html#examples
         if(Lua_FOUND AND NOT TARGET Lua::Lua)
          add_library(Lua::Lua INTERFACE IMPORTED)
            set_target_properties(
              Lua::Lua
              PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES \"$""{LUA_INCLUDE_DIR}\"
                INTERFACE_LINK_LIBRARIES \"$""{LUA_LIBRARIES}\"
            )
         endif()

         find_path(cityhash_INCLUDE_DIR NAMES city.h REQUIRED)
         find_library(cityhash_LIBRARIES cityhash REQUIRED)
         add_library(3rdParty::cityhash INTERFACE IMPORTED)
         set_target_properties(3rdParty::cityhash PROPERTIES
           INTERFACE_INCLUDE_DIRECTORIES \"$""{cityhash_INCLUDE_DIR}\"
           INTERFACE_LINK_LIBRARIES \"$""{cityhash_LIBRARIES}\")

         find_path(RapidXML_INCLUDE_DIR NAMES rapidxml.hpp REQUIRED PATH_SUFFIXES rapidxml)
         add_library(3rdParty::RapidXML INTERFACE IMPORTED)
         set_target_properties(3rdParty::RapidXML PROPERTIES
           INTERFACE_INCLUDE_DIRECTORIES \"$""{RapidXML_INCLUDE_DIR}\")

         find_library(vulkan_validation_layers_LIBRARIES VkLayer_khronos_validation REQUIRED)
         add_library(3rdParty::vulkan-validationlayers INTERFACE IMPORTED)
         set_target_properties(3rdParty::vulkan-validationlayers PROPERTIES
           INTERFACE_LINK_LIBRARIES \"$""{vulkan_validation_layers_LIBRARIES}\")

         find_library(mcpp_LIBRARIES mcpp REQUIRED)
         find_path(mcpp_INCLUDE_DIR mcpp_lib.h REQUIRED)
         add_library(3rdParty::mcpp INTERFACE IMPORTED)
         set_target_properties(3rdParty::mcpp PROPERTIES
           INTERFACE_INCLUDE_DIRECTORIES \"$""{mcpp_INCLUDE_DIR}\"
           INTERFACE_LINK_LIBRARIES \"$""{mcpp_LIBRARIES}\")

         add_library(3rdParty::assimp ALIAS assimp::assimp)
         add_library(3rdParty::expat ALIAS expat::expat)
         add_library(3rdParty::GoogleBenchmark ALIAS benchmark::benchmark)
         add_library(3rdParty::googletest::GMock ALIAS GTest::gmock)
         add_library(3rdParty::googletest::GTest ALIAS GTest::gtest)
         add_library(3rdParty::Lua ALIAS Lua::Lua)
         add_library(3rdParty::lz4 ALIAS LZ4::lz4)
         add_library(3rdParty::OpenSSL ALIAS OpenSSL::SSL)
         add_library(3rdParty::pybind11 ALIAS pybind11::pybind11)
         add_library(3rdParty::Qt::Concurrent ALIAS Qt5::Concurrent)
         add_library(3rdParty::Qt::Core ALIAS Qt5::Core)
         add_library(3rdParty::Qt::Gui ALIAS Qt5::Gui)
         add_library(3rdParty::Qt::Network ALIAS Qt5::Network)
         add_library(3rdParty::Qt::OpenGL ALIAS Qt5::OpenGL)
         add_library(3rdParty::Qt::Svg ALIAS Qt5::Svg)
         add_library(3rdParty::Qt::Test ALIAS Qt5::Test)
         add_library(3rdParty::Qt::Widgets ALIAS Qt5::Widgets)
         add_library(3rdParty::Qt::Xml ALIAS Qt5::Xml)
         add_library(3rdParty::RapidJSON ALIAS RapidJSON)
         add_library(3rdParty::SQLite ALIAS SQLite::SQLite3)
         add_library(3rdParty::SPIRVCross ALIAS spirv-cross-cpp)
         add_library(3rdParty::TIFF ALIAS TIFF::tiff)
         add_library(3rdParty::DirectXShaderCompilerDxc ALIAS Vulkan::dxc_lib)
         add_library(3rdParty::xxhash ALIAS xxHash::xxhash)
         add_library(3rdParty::ZLIB ALIAS ZLIB::ZLIB)
         add_library(3rdParty::zlib ALIAS ZLIB::ZLIB)
         " \
      --replace-fail \
        "include(cmake/LYPython.cmake)" \
        "include(cmake/LySet.cmake)
         include(cmake/3rdPartyPackages.cmake)"

    substituteInPlace cmake/3rdParty/BuiltInPackages.cmake \
      --replace-fail \
        "ly_download_associated_package(ZLIB)" \
        "" \
      --replace-fail \
        "add_library(3rdParty::zlib ALIAS 3rdParty::ZLIB)" \
        ""

    substituteInPlace cmake/3rdPartyPackages.cmake \
      --replace-fail \
        "ly_parse_third_party_dependencies(3rdParty::Qt)" \
        ""

    substituteInPlace cmake/LYWrappers.cmake \
      --replace-fail \
        "ly_qt_uic_target($""{ly_add_target_NAME})" \
        "set_property(TARGET $""{ly_add_target_NAME} PROPERTY AUTOUIC ON)"

    substituteInPlace Code/Editor/CMakeLists.txt \
      --replace-fail \
        "ly_add_translations(" \
        "if(false)
         ly_add_translations(" \
      --replace-fail \
        "ly_add_dependencies(Editor AssetProcessor)" \
        "ly_add_dependencies(Editor AssetProcessor)
         endif()"

    substituteInPlace cmake/LyAutoGen.cmake \
      --replace-fail \
        "add_custom_command(" \
        "if(false)
         add_custom_command(" \
      --replace-fail \
        "target_sources($""{ly_add_autogen_NAME} PRIVATE $""{AUTOGEN_OUTPUTS})" \
        "target_sources($""{ly_add_autogen_NAME} PRIVATE $""{AUTOGEN_OUTPUTS})
         endif()"

    substituteInPlace Gems/Atom/RPI/Tools/CMakeLists.txt \
      --replace-fail \
        "ly_pip_install_local_package_editable($""{CMAKE_CURRENT_LIST_DIR} atom_rpi_tools)" \
        ""
  '';

  cmakeFlags = [
    "-DLY_PACKAGE_DEBUG=ON"
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    assimp
    directx-shader-compiler
    expat
    gbenchmark
    gtest
    cityhash
    libsForQt5.qtbase
    libunwind
    libtiff
    lua54Packages.lua
    lz4
    mcpp
    openssl
    rapidjson
    rapidxml
    spirv-cross
    sqlite
    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
    xxHash
    zstd
    zlib
  ];

  propagatedBuildInputs = [
    python
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "multi-platform 3D engine";
    homepage = "https://o3de.org/";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "o3de";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
