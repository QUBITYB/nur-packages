{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python Inputs
, fastdtw
, numpy
, pandas
, psutil
, qiskit-terra
, qiskit-optimization
, scikitlearn
, scipy
, quandl
, yfinance
  # Check Inputs
, pytestCheckHook
, ddt
, pytest-timeout
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-finance";
  version = "0.3.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    sha256 = "sha256-17loUE8pXD/TQhVMh3oC2yNMXlYcCBx9Effaq1Io/fI=";
  };

  propagatedBuildInputs = [
    fastdtw
    numpy
    pandas
    psutil
    qiskit-terra
    qiskit-optimization
    quandl
    scikitlearn
    scipy
    yfinance
  ];

  checkInputs = [
    pytestCheckHook
    pytest-timeout
    ddt
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_finance" ];
  disabledTests = [
    # Fail due to approximation error, ~1-2%
    "test_application"

    # Tests fail b/c require internet connection. Stalls tests if enabled.
    "test_exchangedata"
    "test_yahoo"
    "test_wikipedia"
  ];
  pytestFlagsArray = [
    "--durations=10"
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-optimization/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
