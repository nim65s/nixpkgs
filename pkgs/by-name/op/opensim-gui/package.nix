{
  breakpointHook,
  vim,
  lib,
  stdenv,
  fetchFromGitHub,

  buildNpmPackage,

  ant,
  cmake,
  jdk,
  netbeans,
  nodejs,
  xmlstarlet,

  blas,
  lapack,
  opensim-core,
  simbody,
  spdlog,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensim-gui";
  version = "4.6";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "opensim-org";
    repo = "opensim-gui";
    tag = finalAttrs.version;
    hash = "sha256-1d74mNpzektx4j35Te1XvEnhjO6KD/Z7vvmx2jND+pk=";
    fetchSubmodules = true; # nor opensim-models, opensim-visualizer & opensim-viewer
  };

  npmRoot = "Gui/opensim/opensim-viewer";
  postPatch =
    let
      opensim-viewer = buildNpmPackage {
        pname = "opensim-viewer";
        inherit (finalAttrs) version src;
        sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
        npmDepsHash = "sha256-AZilhv4Ij20D64oo4AwE0do1OhIJZRG8zLOA1idKdWE=";
        installPhase = ''
          runHook preInstall
          cp -r build $out
          runHook postInstall
        '';
      };
    in
    ''
      substituteInPlace Gui/opensim/build.xml --replace-fail \
        "npm.cmd" \
        "${lib.getExe' nodejs "npm"}"

      mkdir -p ${finalAttrs.npmRoot}/build
      cp -r ${opensim-viewer}/* ${finalAttrs.npmRoot}/build/
    '';

  nativeBuildInputs = [
    breakpointHook
    vim
    ant
    cmake
    netbeans
    nodejs
    jdk
    xmlstarlet
  ];

  buildInputs = [
    blas
    lapack
    opensim-core
    simbody
    spdlog
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ANT_ARGS" (
      lib.concatStringsSep ";" [
        "-Dnbplatform.default.netbeans.dest.dir=${netbeans}/netbeans"
        "-Dnbplatform.default.harness.dir=${netbeans}/netbeans/harness"
      ]
    ))
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SimTK OpenSim graphical user interface and distribution";
    homepage = "https://github.com/opensim-org/opensim-gui";
    changelog = "https://github.com/opensim-org/opensim-gui/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "opensim-gui";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
