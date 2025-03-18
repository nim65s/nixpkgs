{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  matplotlib,
  numpy,
}:

buildPythonPackage rec {
  pname = "xtcocotools";
  version = "1.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jin-s13";
    repo = "xtcocoapi";
    rev = "v${version}";
    hash = "sha256-INEWKn9XCraLxBzNZ6IMm9/gxbAsuZdKHapHvJ/bGfQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cython
    matplotlib
    numpy
    setuptools
  ];

  pythonImportsCheck = [
    "xtcocotools"
  ];

  meta = {
    description = "Extended COCO API";
    homepage = "https://github.com/jin-s13/xtcocoapi";
    license = lib.licenses.MIT;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
