{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  ispc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ispc-texture-compressor";
  version = "0-unstable-2024-09-23";

  src = fetchFromGitHub {
    owner = "GameTechDev";
    repo = "ISPCTextureCompressor";
    rev = "79ddbc90334fc31edd438e68ccb0fe99b4e15aab";
    hash = "sha256-uPdY+tNLhmgENe3qg3+hq1JgoEes5yazf4Hmqu49I8E=";
  };

  makeFlags = [
    "ISPC=${lib.getExe ispc}"
    "uname_P=${stdenv.hostPlatform.linuxArch}"
    "-f"
    "Makefile.linux"
  ];

  nativeBuildInputs = [
    ispc
  ];

  installPhase = ''
    runHook preInstall

    install -D build/libispc_texcomp.so -t $out/lib
    install -D ispc_texcomp/ispc_texcomp.h -t $out/include/ISPC

    runHook postInstall
  '';

  meta = {
    description = "ISPC Texture Compressor";
    homepage = "https://github.com/GameTechDev/ISPCTextureCompressor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "ispc-texture-compressor";
    platforms = lib.platforms.linux;
  };
})
