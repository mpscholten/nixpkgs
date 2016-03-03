{ stdenv, fetchgit, zlib, bzip2
}:

stdenv.mkDerivation {
  name = "undmg";

  src = fetchgit {
    url = https://github.com/matthewbauer/undmg.git;
    sha256 = "0f2hhb85nwva1grj18q3rib48rgscavnrzqp5mdwxwrywqm9q4pl";
  };

  buildInputs = [ zlib bzip2 ];

  setupHook = ./setup-hook.sh;

  installPhase = ''
    mkdir -p "$out/bin"
    chmod +x undmg
    mv undmg "$out/bin"
  '';

  meta = {
    homepage = https://github.com/matthewbauer/undmg;
    description = "Extract a DMG file";
    license = stdenv.lib.licenses.gpl3; # http://www.info-zip.org/license.html
    platforms = stdenv.lib.platforms.all;
  };
}
