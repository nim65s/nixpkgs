{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  appdirs,
  coloredlogs,
  matplotlib,
  numpy,
  pillow,
  pyquaternion,
  requests,
  tqdm,
  typing,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "cityscapes-scripts";
  version = "2.2.4";
  pyproject = true;

  # https://github.com/mcordts/cityscapesScripts has no tags
  src = fetchPypi {
    pname = "cityscapesscripts";
    inherit version;
    hash = "sha256-qnCccalM7YZwh6zb4vEyhIME+gArJDD2wx8zI8vp1OY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    appdirs
    coloredlogs
    matplotlib
    numpy
    pillow
    pyquaternion
    requests
    tqdm
    typing
  ];

  optional-dependencies = {
    gui = [
      pyqt5
    ];
  };

  pythonImportsCheck = [
    "cityscapes_scripts"
  ];

  meta = {
    description = "Scripts for the Cityscapes Dataset";
    homepage = "https://pypi.org/project/cityscapesScripts/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
