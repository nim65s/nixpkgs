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
  libunwind,
  lua54Packages,
  rapidjson,
  rapidxml,
  zstd,
  zlib,

  # propagatedBuildInputs
  python3,
}:
let
  # cat python/requirements.txt | grep == | cut -d= -f1
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
         find_package(Lua REQUIRED)
         find_package(Python REQUIRED)
         find_package(Qt5 REQUIRED COMPONENTS Concurrent Core Gui Network OpenGL Svg Test Widgets Xml)
         find_package(RapidJSON REQUIRED)
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

         find_path(RapidXML_INCLUDE_DIR NAMES rapidxml.hpp REQUIRED PATH_SUFFIXES rapidxml)
         add_library(RapidXML::RapidXML INTERFACE IMPORTED)
         set_target_properties(RapidXML::RapidXML PROPERTIES INTERFACE_INCLUDE_DIRECTORIES \"$""{RapidXML_INCLUDE_DIR}\")

         add_library(3rdParty::Lua ALIAS Lua::Lua)
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
         add_library(3rdParty::RapidXML ALIAS RapidXML::RapidXML)
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
    libsForQt5.qtbase
    libunwind
    lua54Packages.lua
    rapidjson
    rapidxml
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
