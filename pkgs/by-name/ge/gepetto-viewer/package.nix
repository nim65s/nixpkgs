{
  boost,
  cmake,
  darwin,
  doxygen,
  fetchFromGitHub,
  fontconfig,
  lib,
  jrl-cmakemodules,
  libsForQt5,
  makeWrapper,
  openscenegraph,
  osgqt,
  pkg-config,
  python3Packages,
  qgv,
  stdenv,
  runCommand,
}:
let
  gepetto-viewer = stdenv.mkDerivation (finalAttrs: {
    pname = "gepetto-viewer";
    version = "5.1.0";

    src = fetchFromGitHub {
      owner = "gepetto";
      repo = "gepetto-viewer";
      rev = "v${finalAttrs.version}";
      hash = "sha256-A2J3HidG+OHJO8LpLiOEvORxDtViTdeVD85AmKkkOg8=";
    };

    cmakeFlags = [
      (lib.cmakeBool "BUILD_PY_QCUSTOM_PLOT" (!stdenv.isDarwin))
      (lib.cmakeBool "BUILD_PY_QGV" (!stdenv.isDarwin))
    ];

    outputs = [
      "out"
      "doc"
    ];

    buildInputs = [
      python3Packages.boost
      python3Packages.python-qt
      libsForQt5.qtbase
    ];

    nativeBuildInputs = [
      cmake
      doxygen
      libsForQt5.wrapQtAppsHook
      pkg-config
      python3Packages.python
    ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ darwin.autoSignDarwinBinariesHook ];

    propagatedBuildInputs = [
      jrl-cmakemodules
      openscenegraph
      osgqt
      qgv
    ];

    doCheck = true;

    # wrapQtAppsHook uses isMachO, which fails to detect binaries without this
    # ref. https://github.com/NixOS/nixpkgs/pull/138334
    preFixup = lib.optionalString stdenv.isDarwin "export LC_ALL=C";

    # Fontconfig error: Cannot load default config file: No such file: (null)
    env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

    # Fontconfig error: No writable cache directories
    preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

    passthru.withPlugins =
      plugins:
      runCommand "gepetto-gui"
        {
          inherit (gepetto-viewer) meta;
          nativeBuildInputs = [ makeWrapper ];
          propagatedBuildInputs = [ gepetto-viewer ] ++ plugins;
        }
        ''
          makeWrapper ${lib.getExe gepetto-viewer} $out/bin/gepetto-gui \
            --set GEPETTO_GUI_PLUGIN_DIRS ${lib.makeLibraryPath plugins}
        '';

    meta = {
      description = "Graphical Interface for Pinocchio and HPP.";
      homepage = "https://github.com/gepetto/gepetto-viewer";
      license = lib.licenses.lgpl3Only;
      maintainers = [ lib.maintainers.nim65s ];
      mainProgram = "gepetto-gui";
      platforms = lib.platforms.unix;
    };
  });
in
gepetto-viewer
