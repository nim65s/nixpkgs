{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # buildInputs
  antlr,
  cli11,

  # nativeInstallCheckInputs
  python3,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "o3de-azslc";
  version = "1.8.22";

  src = fetchFromGitHub {
    owner = "o3de";
    repo = "o3de-azslc";
    tag = finalAttrs.version;
    hash = "sha256-nAG3bFKxQOBjVzp5eXKRPdexCfvyiwv2qnC4d4RZ70s=";
  };

  postPatch = ''
    # ref. https://github.com/o3de/o3de-azslc/pull/93

    substituteInPlace src/StreamableInterface.h \
      --replace-fail \
        "#include <ostream>" \
        "#include <cstdint>
         #include <ostream>"

    # ref. https://github.com/o3de/o3de-azslc/pull/94

    echo "install(TARGETS azslc DESTINATION bin)" >> src/CMakeLists.txt

    substituteInPlace src/CMakeLists.txt \
      --replace-fail \
        "FetchContent_MakeAvailable(cli11 antlr4)" \
        "find_package(CLI11 REQUIRED)
         find_library(antlr4_runtime_LIBRARY antlr4-runtime REQUIRED)
         set(antlr4_SOURCE_DIR \"${antlr.runtime.cpp.src}\")" \
      --replace-fail \
        "antlr4_static" \
        "$""{antlr4_runtime_LIBRARY}"

    substituteInPlace src/AzslcMain.cpp \
      --replace-fail \
        "(- | FILE)" \
        "FILE"

    # ref. https://github.com/o3de/o3de-azslc/pull/95

    substituteInPlace src/AzslcMain.cpp \
      --replace-quiet \
        'AZSLC_REVISION "20"' \
        'AZSLC_REVISION "22"'
  '';

  # source need to be writeable for tests,
  # so don't set sourceRoot to "${finalAttrs.src.name}/src"
  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    antlr.runtime.cpp
    cli11
  ];

  nativeInstallCheckInputs = [
    (python3.withPackages (p: [ p.pyyaml ]))
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  # ref. tests/launch_tests_linux.sh
  installCheckPhase = ''
    runHook preInstallCheck

    pushd ../../tests
    python testapp.py --silent --compiler "$out/bin/azslc" --path Syntax Semantic Advanced
    popd

    runHook postInstallCheck
  '';

  meta = {
    description = "Amazon Shader Language (AZSL) Compiler";
    homepage = "https://github.com/o3de/o3de-azslc";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "azslc";
    platforms = lib.platforms.all;
  };
})
