{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycocoevalcap";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "salaniz";
    repo = "pycocoevalcap";
    rev = "v${version}";
    hash = "sha256-LcMcxRF8IVu7t05GXVXKzsFBxdP+LllfuV3vCGNdYvk=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pycocoevalcap"
  ];

  meta = {
    description = "Python 3 support for the MS COCO caption evaluation tools";
    homepage = "https://github.com/salaniz/pycocoevalcap";
    license = lib.licenses.bsd2WithViews;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
