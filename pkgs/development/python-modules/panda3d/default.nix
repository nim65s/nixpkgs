{
  buildPythonPackage,
  fetchFromGitHub,
  autoPatchelfHook,
  pypaInstallHook,
  lib,
  setuptools,
  pkg-config,
  assimp,
  bullet,
  eigen,
  ffmpeg,
  fftw,
  freetype,
  gdbm,
  glibcLocales,
  gtk2,
  harfbuzz,
  libjpeg,
  libglvnd,
  libogg,
  libopus,
  libpng,
  libtiff,
  libvorbis,
  libxcrypt,
  mesa,
  mpdecimal,
  ode,
  openal,
  openexr,
  openssl,
  opusfile,
  readline,
  sqlite,
  pytest,
  python3,
  stdenv,
  xorg,
  zlib,
}:

buildPythonPackage rec {
  pname = "panda3d";
  version = "1.10.15";
  pyproject = false; # custom build script

  src = fetchFromGitHub {
    owner = "panda3d";
    repo = "panda3d";
    rev = "refs/tags/v${version}";
    hash = "sha256-1IwOTs9gc6OwQmvaaU4yoWK/TfNbEJKNRPorsdIayDg=";
  };

  # fix utf8 locale issue
  env.LOCALE_ARCHIVE = lib.optionalString stdenv.hostPlatform.isLinux "${glibcLocales}/lib/locale/locale-archive";

  dontConfigure = true;

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    pypaInstallHook
  ];
  build-system = [
    setuptools
  ];
  buildInputs = [
    assimp
    bullet
    eigen
    ffmpeg
    fftw
    freetype
    gdbm
    gtk2
    harfbuzz
    libjpeg
    libglvnd
    libogg
    libopus
    libpng
    libtiff
    libvorbis
    libxcrypt
    mesa
    mpdecimal
    ode
    openal
    openexr
    openssl
    opusfile
    readline
    sqlite
    xorg.libX11
    xorg.libXcursor
    xorg.xrandr
    xorg.libXxf86dga
    zlib
  ];

  postPatch = ''
    patchShebangs ./makepanda/makepanda.py

    # Cannot build wheel otherwise (zip 1980 issue)
    substituteInPlace makepanda/makewheel.py --replace-fail \
      "zipfile.ZIP_DEFLATED" \
      "zipfile.ZIP_DEFLATED, strict_timestamps=False"

    # ease debugging the build
    substituteInPlace makepanda/makepandacore.py --replace-fail \
      "VERBOSE = False" \
      "VERBOSE = True"
  '';

  buildPhase =
    let
      dirs = n: v: "--${n}-incdir ${lib.getDev v}/include --${n}-libdir ${lib.getLib v}/lib";
      paths = lib.mapAttrsToList dirs {
        jpeg = libjpeg;
        png = libpng;
        python = python3;
      };
    in
    ''
      runHook preBuild

      ./makepanda/makepanda.py ${lib.concatStringsSep " " paths} \
        --everything \
        --tests \
        --wheel

      runHook postBuild
    '';

  # custom build script put wheel in ./
  # but pypaInstallHook expect it in ./dist/
  preInstall = ''
    mkdir -p dist
    mv *.whl dist
  '';

  nativeCheckInputs = [ pytest ];  # pytest is run by makepanda.py
  pythonImportsCheck = [
    "panda3d"
    "panda3d.core"
  ];

  meta = {
    description = "Powerful, mature open-source cross-platform game engine for Python and C++, developed by Disney and CMU";
    homepage = "https://github.com/panda3d/panda3d";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    # TODO: Darwin & Windows are supposed to work too, but I can't test right now
    platforms = lib.platforms.linux;
  };
}
