{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  numpy,
  pip,
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

  patches = [
    # Delete unused and deprecated import
    # This was merged upstream and can be removed on next release
    (fetchpatch {
      url = "https://github.com/mattloper/chumpy/pull/48.patch";
      hash = "sha256-C3IJnvprztV2BVHz+pWyKgwK9t6fnLXlwZccVS7mPSY=";
    })
  ];

  # Fix for python > 3.11
  postPatch = ''
    substituteInPlace chumpy/ch.py --replace-fail \
      "want_out = 'out' in inspect.getargspec(func).args" \
      "want_out = 'out' in inspect.getfullargspec(func).args"
  '';

  build-system = [
    setuptools
    pip  # setup.py has 'from pip._internal.req import parse_requirements'
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
