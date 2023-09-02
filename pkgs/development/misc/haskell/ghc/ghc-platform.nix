{ mkDerivation
, base
, lib
, fetchFromGitLab
}:
mkDerivation {
  pname = "ghc-platform";
  version = "v.0.1.0.0";
  src = (fetchFromGitLab {
    domain = "gitlab.haskell.org";
    owner = "ghc";
    repo = "ghc";
    rev = "3ac423b9645998b178badb6edc7bf3328e7d9e4e";
  }) + "libraries/ghc-platform";
  isLibrary = true;
  isExecutable = false;
  libraryHaskellDepends = [base];
  license = lib.licenses.bsd3;
  homepage = "https://gitlab.haskell.org/";
}
