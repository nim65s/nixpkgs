{
  lib,
  buildPythonApplication,

  uv-build,
  zenoh,
}:
let
  pyproject = lib.importTOML ./pyproject.toml;
in
buildPythonApplication (_finalAttrs: {
  inherit (pyproject.project) name version;
  pyproject = true;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./pyproject.toml
      ./README.md
      ./src
    ];
  };

  build-system = [ uv-build ];
  dependencies = [ zenoh ];
  pythonImportsCheck = [ pyproject.project.name ];

  meta.mainProgram = pyproject.project.name;
})
