{
  cmake,
  coin3d,
  doxygen,
  eigen,
  fetchFromGitHub,
  lapack,
  lib,
  libdc1394,
  libdmtx,
  libglvnd,
  libjpeg, # this is libjpeg-turbo
  libpng,
  librealsense,
  libxml2,
  libx11,
  llvmPackages,
  nlohmann_json,
  #ogre,
  openblas,
  opencv,
  perl,
  pkg-config,
  python3,
  stdenv,
  texliveSmall,
  libv4l,
  libpthread-stubs,
  zbar,
  zlib,
}:

let
  # only required for building bindings, stubs & docs
  python = python3.withPackages (
    p: with p; [
      cxxheaderparser
      doxmlparser
      lxml
      mypy
      numpy
      pcpp
      pip
      pybind11
      setuptools
      sphinx
      sphinx-design
      sphinxcontrib-jsmath
      tqdm
      wheel
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "visp";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "lagadic";
    repo = "visp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sC7HB/eOiXURPTxRTbUHV6Ws7o9dcUwEG3Y0GezN7kw=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    perl
    pkg-config
    python
    texliveSmall
  ];

  buildInputs = [
    eigen
    lapack
    libdc1394
    libdmtx
    libglvnd
    libjpeg
    libpng
    librealsense
    libx11
    libxml2
    nlohmann_json
    #ogre
    openblas
    opencv
    libpthread-stubs
    zbar
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    coin3d
    libv4l
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  env = {
    # cmake use multiple pip install and custom setup.py
    # to build bindings, stubs, and docs
    PIP_PREFIX = placeholder "out";
    PIP_NO_BUILD_ISOLATION = "0"; # https://github.com/pypa/pip/issues/5735
    PIP_NO_DEPS = "1";
    PIP_BREAK_SYSTEM_PACKAGES = "1"; # we want to write in $out, which is /nix/store
    # and need to run things from there
    PYTHONPATH = "${placeholder "out"}/${python.sitePackages}";
  };

  cmakeFlags = [
    (lib.cmakeBool "ALLOW_SYSTEM_PYTHON" true)
  ];

  postInstall = ''
    # bindings are not in ALL
    make visp_python_bindings

    # and contain forbidden references to /build/
    _visp=$out/${python.sitePackages}/visp/_visp.*
    _rpath=$(patchelf --print-rpath $_visp | tr ':' '\n' | sed '/^\/build/d' | tr '\n' ':')
    patchelf --set-rpath $_rpath $_visp
  '';

  doCheck = true;

  nativeCheckInputs = [
    python3.pkgs.pythonImportsCheckHook
  ];

  pythonImportsCheck = [ "visp" ];

  meta = {
    description = "Open Source Visual Servoing Platform";
    homepage = "https://visp.inria.fr";
    changelog = "https://github.com/lagadic/visp/blob/v${finalAttrs.version}/ChangeLog.txt";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
