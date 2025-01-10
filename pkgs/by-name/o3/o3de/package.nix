{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libunwind,
  zstd,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "o3de";
  version = "2409.1";

  src = fetchFromGitHub {
    owner = "o3de";
    repo = "o3de";
    rev = version;
    hash = "sha256-PLsEpcCbRlvOnaEYjGJ/PqS/LtpreXjWyX5h0DEKo5s=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libunwind
    zstd
    zlib
  ];

  preConfigure = ''
    HOME=$(mktemp -d)
  '';

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
}
