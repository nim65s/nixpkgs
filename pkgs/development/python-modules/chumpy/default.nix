{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  scipy,
  six,
}:

buildPythonPackage rec {
  pname = "chumpy";
  version = "0.70";
  pyproject = true;

  # https://github.com/mattloper/chumpy has no tags
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oCdcIBh4TKEwKHVWfcgXYfX9Rp+rnzrA8+fDnpGANQo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    six
  ];

  pythonImportsCheck = [
    "chumpy"
  ];

  meta = {
    description = "Chumpy";
    homepage = "https://pypi.org/project/chumpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
