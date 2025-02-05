{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, fmt
, nlohmann_json
, python3
}:
stdenv.mkDerivation rec {
  pname = "tweedledum";
  version = "a4549579873b69466d32600b6a7f2e68f5486aee";

  src = fetchFromGitHub{
    owner = "boschmitt";
    repo = "tweedledum";
    rev = "a4549579873b69466d32600b6a7f2e68f5486aee";
    sha256 = "0f30i0v2dyjkfygf0irjfsk8acp5ncypkjshy2nv7cyp3rgnkqad";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [
    nlohmann_json
    (python3.withPackages(ps: [ ps.pybind11 ]))
  ];

  cmakeFlags = [
    "-DTWEEDLEDUM_PYBINDS=OFF"
    "-DTWEEDLEDUM_TESTS=ON"
    "-DTWEEDLEDUM_USE_EXTERNAL_PYBIND11=ON"
  ];

  doCheck = true;
  doInstallCheck = true;

  checkPhase = ''
    ./tests/run_tests
  '';

  meta = with lib; {
    description = "Library for writing, manipulating, and optimizing quantum circuits";
    homepage = "https://github.com/boschmitt/tweedledum";
    license = licenses.mit ;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
