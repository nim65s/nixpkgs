{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libsodium,
  asciidoc,
  xmlto,
  enableDrafts ? false,
  # for passthru.tests
  azmq,
  cppzmq,
  czmq,
  zmqpp,
  ffmpeg,
  python3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zeromq";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q2h5y0Asad+fGB9haO4Vg7a1ffO2JSb7czzlhmT3VmI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    asciidoc
    xmlto
  ];

  buildInputs = [ libsodium ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ENABLE_CURVE" true)
    (lib.cmakeBool "ENABLE_DRAFTS" enableDrafts)
    (lib.cmakeBool "WITH_LIBSODIUM" true)
  ];

  # Fix build with CMake v4
  # ref https://github.com/zeromq/libzmq/pull/4776
  # This was merged upstream and can be removed on next release
  patches = [
    (fetchpatch {
      url = "https://github.com/zeromq/libzmq/commit/34f7fa22022bed9e0e390ed3580a1c83ac4a2834.patch";
      hash = "sha256-oauAZV6pThplcn2v9mQxhxlUhYgpbly0JBLYik+zoJE=";
    })
    (fetchpatch {
      url = "https://github.com/zeromq/libzmq/pull/4776/commits/1e65e8e61d693b14dd2f9e3ace4ffae46159691c.patch";
      hash = "sha256-FKvZi7pTUx+wLUR8Suf+pRFg8I5OHpJ93gEmTxUrmO4=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  postBuild = ''
    # From https://gitlab.archlinux.org/archlinux/packaging/packages/zeromq/-/blob/main/PKGBUILD
    # man pages aren't created when using cmake
    # https://github.com/zeromq/libzmq/issues/4160
    pushd ../doc
    for FILE in *.txt; do
        asciidoc \
            -d manpage \
            -b docbook \
            -f asciidoc.conf \
            -a zmq_version="${finalAttrs.version}" \
            "''${FILE}"
        xmlto --skip-validation man "''${FILE%.txt}.xml"
    done
    popd
  '';

  postInstall = ''
    # Install manually created man pages
    install -vDm644 -t "$out/share/man/man3" ../doc/*.3
    install -vDm644 -t "$out/share/man/man7" ../doc/*.7
  '';

  passthru.tests = {
    inherit
      azmq
      cppzmq
      czmq
      zmqpp
      ;
    pyzmq = python3.pkgs.pyzmq;
    ffmpeg = ffmpeg.override { withZmq = true; };
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "Intelligent Transport Layer";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
    pkgConfigModules = [ "libzmq" ];
  };
})
