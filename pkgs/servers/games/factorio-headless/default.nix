{ stdenv, callPackage, fetchurl, makeWrapper, gnutar
# Begin libraries
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi
}:

let
  version = "0.12.28";
in

stdenv.mkDerivation rec {
  name = "factorio-headless-${version}";

  src = fetchurl {
    url = "https://www.factorio.com/get-download/${version}/headless/linux64";
    sha256 = "0wlgbqiksf17dq96yl40fgwrpbzwhzqnch2rv73gnzx009c3jj3q";
    name = "factorio.tar.gz";
  };

  libPath = stdenv.lib.makeLibraryPath [
    alsaLib
    libX11
    libXcursor
    libXinerama
    libXrandr
    libXi
  ];

  buildInputs = [ makeWrapper gnutar ];

  installPhase = ''
    mkdir -p $out/{bin,share/factorio-headless}
    cp -a bin/x64/factorio $out/bin/factorio-headless
    cp -a data $out/share/factorio-headless

    # Fortunately, Factorio already supports system-wide installs.
    # Unfortunately it's a bit inconvenient to set the paths.
    cat > $out/share/factorio-headless/config-base.cfg <<EOF
use-system-read-write-data-directories=false
[path]
read-data=$out/share/factorio-headless/data/
EOF

    cat > $out/share/factorio-headless/update-config.sh <<EOF
if [[ -e ~/.factorio-headless/config.cfg ]]; then
  # Config file exists, but may have wrong path.
  # Try to edit it. I'm sure this is perfectly safe and will never go wrong.
  sed -i 's|^read-data=.*|read-data=$out/share/factorio-headless/data/|' ~/.factorio-headless/config.cfg
else
  # Config file does not exist. Phew.
  install -D $out/share/factorio-headless/config-base.cfg ~/.factorio-headless/config.cfg
fi
EOF
    chmod a+x $out/share/factorio-headless/update-config.sh

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/factorio-headless

    makeWrapper $out/bin/factorio-headless $out/bin/factorio-headless \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$libPath \
      --run "$out/share/factorio-headless/update-config.sh" \
      --add-flags "-c \$HOME/.factorio-headless/config.cfg"
  '';

  meta = {
    description = "A game in which you build and maintain factories";
    longDescription = ''
      Factorio is a game in which you build and maintain factories.

      You will be mining resources, researching technologies, building
      infrastructure, automating production and fighting enemies. Use your
      imagination to design your factory, combine simple elements into
      ingenious structures, apply management skills to keep it working and
      finally protect it from the creatures who don't really like you.

      Factorio has been in development since spring of 2012 and it is
      currently in late alpha.
    '';
    homepage = https://www.factorio.com/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.Baughn ];
    platforms = [ "x86_64-linux" ];
  };
}
