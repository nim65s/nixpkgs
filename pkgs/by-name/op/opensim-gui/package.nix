{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
    hash = "sha256-d/Y93jCvMJvLn+Z1VFsmpW4McNcvQJY2rRAB3JEkAks=";
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SimTK OpenSim graphical user interface and distribution";
    homepage = "https://github.com/opensim-org/opensim-gui";
    changelog = "https://github.com/opensim-org/opensim-gui/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "opensim-gui";
    platforms = lib.platforms.all;
  };
})
