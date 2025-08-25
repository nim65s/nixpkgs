{
  lib,
  stdenv,

  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,

  # buildInputs
  libunwind,
  zstd,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "o3de";
  version = "2409.1";

  src = fetchFromGitHub {
    owner = "o3de";
    repo = "o3de";
    tag = finalAttrs.version;
    hash = "sha256-PLsEpcCbRlvOnaEYjGJ/PqS/LtpreXjWyX5h0DEKo5s=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libunwind
    zstd
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "multi-platform 3D engine";
    homepage = "https://github.com/o3de/o3de";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "o3de";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
