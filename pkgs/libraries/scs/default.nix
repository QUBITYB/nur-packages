{ stdenv
, lib
, fetchFromGitHub
, blas
, liblapack
, gfortran
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "scs";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "cvxgrp";
    repo = "scs";
    rev = "v${version}";
    sha256 = "sha256-VU+iTsVCJl+Lxk43+F0wjJdWpYRpW+S9FEdgLTfP9Vc=";
  };

  # Actually link and add libgfortran to the rpath
  postPatch = ''
    substituteInPlace scs.mk \
      --replace "#-lgfortran" "-lgfortran" \
      --replace "gcc" "cc"
  '';

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ blas liblapack gfortran.cc.lib ];

  doCheck = true;

  # Test demo requires passing data and seed; numbers chosen arbitrarily.
  postCheck = ''
    ./out/demo_socp_indirect 42 0.42 0.42 42
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp -r include $out/
    cp out/*.a out/*.so out/*.dylib $out/lib/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Splitting Conic Solver";
    longDescription = ''
      Numerical optimization package for solving large-scale convex cone problems
    '';
    homepage = "https://github.com/cvxgrp/scs";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bhipple ];
  };
}
