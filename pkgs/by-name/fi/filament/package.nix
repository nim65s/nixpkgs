{
  cmake,
  clangStdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libcxx,
  libffi,
  libglvnd,
  libX11,
  libXcomposite,
  libxkbcommon,
  libXi,
  libXxf86vm,
  pkg-config,
  python3Packages,
  # TODO : withWayland broken, because:
  # > No rule to make target '//nix/store/cdnwvy5zyh6la8x1cal00xmvsj8x3dai-wayland-1.23.1/share/wayland/wayland.xml',
  # > needed by 'autogen/wayland/wayland-client-protocol.c'.  Stop.
  withWayland ? false,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "filament";
  version = "1.55.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "filament";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0LJMB6mWouXylFsTjBfeeQmRkhr5FjNZKfF47M+AxPM=";
  };

  patches = [
    # Fix missing includes
    (fetchpatch {
      url = "https://github.com/google/filament/pull/8205/commits/ea23430f3582c1a84049da671c1d9a5a6031e1d8.patch";
      hash = "sha256-LBxzETcYB5NlP62sSv3mPkSdw8TdAMCCWzlbEtElxRY=";
    })
  ];

  postPatch = ''
    patchShebangs --build build/linux/combine-static-libs.sh
  '';

  nativeBuildInputs = [
    cmake
    python3Packages.python
    pkg-config
  ] ++ lib.optional (clangStdenv.isLinux && withWayland) wayland-scanner;

  buildInputs =
    [
      libcxx
      libffi
      libglvnd
    ]
    ++ lib.optionals (clangStdenv.isLinux && !withWayland) [
      libXi
      libXcomposite
      libxkbcommon
      libXxf86vm
      libX11
    ]
    ++ lib.optionals (clangStdenv.isLinux && withWayland) [
      wayland
      wayland-protocols
    ];

  cmakeFlags = [
    (lib.cmakeBool "FILAMENT_ENABLE_LTO" true)
    (lib.cmakeBool "FILAMENT_SUPPORTS_METAL" clangStdenv.isDarwin)
    (lib.cmakeBool "FILAMENT_SUPPORTS_VULKAN" clangStdenv.isLinux)
    (lib.cmakeBool "FILAMENT_SUPPORTS_WAYLAND" (clangStdenv.isLinux && withWayland))
    (lib.cmakeBool "USE_STATIC_LIBCXX" clangStdenv.isDarwin)
  ];

  meta = with lib; {
    description = "Real-time physically based rendering engine for Android, iOS, Windows, Linux, macOS, and WebGL2";
    homepage = "https://github.com/google/filament";
    license = licenses.asl20;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix ++ platforms.windows;
  };
})
