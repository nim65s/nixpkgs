{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jsonpatch,
  networkx,
  numpy,
  pillow,
  requests,
  scipy,
  six,
  tornado,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "visdom";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "visdom";
    rev = "refs/tags/v${version}";
    hash = "sha256-Tqapmw7ckU1FYuKvQWBbNvUdJd3cIXvbOX4rO5ifM7M=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    jsonpatch
    networkx
    numpy
    pillow
    requests
    scipy
    six
    tornado
    websocket-client
  ];

  pythonImportsCheck = [
    "visdom"
  ];

  meta = {
    description = "flexible tool for creating, organizing, and sharing visualizations of live, rich data";
    homepage = "https://github.com/fossasia/visdom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
