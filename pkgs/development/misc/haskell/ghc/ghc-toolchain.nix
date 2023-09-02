{ mkDerivation
, base
, lib
, directory
, filepath
, process
, transformers
, text
, ghc-platform
, fetchFromGitLab
}:
mkDerivation {
  pname = "ghc-toolchain";
  version = "v.0.1.0.0";
  src = (fetchFromGitLab {
    domain = "gitlab.haskell.org";
    owner = "ghc";
    repo = "ghc";
    rev = "3ac423b9645998b178badb6edc7bf3328e7d9e4e";
  }) + "utils/ghc-toolchain";
  isLibrary = true;
  isExecutable = false;
  libraryHaskellDepends = [base directory filepath process transformers text ghc-platform];
  license = lib.licenses.bsd3;
  homepage = "https://gitlab.haskell.org/";
}
