{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,

  mmcv,
  mmdet,

  # requirements/build.txt
  numpy,
  torch,

  # requirements/runtime.txt
  chumpy,
  json-tricks,
  matplotlib,
  munkres,
  opencv-python,
  pillow,
  scipy,
  torchvision,
  xtcocotools,

  # requirements/tests.txt
  coverage,
  flake8,
  interrogate,
  isort,
  parameterized,
  pytest,
  #pytest-runner,
  xdoctest,
  yapf,

  # requirements/optional.txt
  requests,
}:

buildPythonPackage rec {
  pname = "mmpose";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmpose";
    rev = "v${version}";
    hash = "sha256-PKdpz6PKK95qZk9Rj+k+QUWwfW3mjWwL6YoqzR2ViI0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mmcv

    # requirements/build.txt
    numpy
    torch

    # requirements/runtime.txt
    chumpy
    json-tricks
    matplotlib
    munkres
    opencv-python
    pillow
    scipy
    torchvision
    xtcocotools

    # requirements/optional.txt
    requests
  ];

  checkInputs = [
    mmdet
    pytestCheckHook

    # requirements/tests.txt
    coverage
    flake8
    interrogate
    isort
    parameterized
    pytest
    #pytest-runner
    xdoctest
    yapf
  ];

  doCheck = true;

  disabledTestPaths = [
    # need mmcv < 2
    "projects/pose_anything/datasets/datasets/mp100/test_base_dataset.py"
    "projects/pose_anything/datasets/datasets/mp100/test_dataset.py"
    "tests/test_external/test_mim.py"

    # ImportError: cannot import name 'inference_bottom_up_pose_model' from 'mmpose.apis
    "tools/torchserve/test_torchserver.py"
  ];

  pythonImportsCheck = [
    "mmpose"
  ];

  meta = {
    description = "OpenMMLab Pose Estimation Toolbox and Benchmark";
    homepage = "https://github.com/open-mmlab/mmpose";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
