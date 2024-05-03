{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pystitcher";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MYSrD+DWm+YUHMH0FK04w6IBUFuy4cxoH5Fw0Z7w4gg=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    html5lib
    importlib-metadata
    markdown
    pypdf3
    validators
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    testing = [
      pytest
      pytest-cov
      setuptools
    ];
  };

  pythonImportsCheck = [ "pystitcher" ];

  meta = with lib; {
    description = "Stitch together a PDF file from multiple sources in a declarative manner";
    homepage = "https://pypi.org/project/pystitcher/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "pystitcher";
  };
}
