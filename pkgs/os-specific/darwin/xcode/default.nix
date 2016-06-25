{ stdenv }:

with stdenv.lib;
let 
  osxVersion = "10.11";
in stdenv.mkDerivation rec {
  name = "xcode-${version}";
  version = "7.3.1";

  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];
  outputs = [ "out" "toolchain" ];

  impureXcodeLocation = "/Applications/Xcode.app";
  impureSdkPath = "${impureXcodeLocation}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs";

  preUnpack = ''
    (${impureXcodeLocation}/Contents/Developer/usr/bin/xcodebuild -version > /dev/null) || (echo "Xcode was not found. Please install it via the App Store" && exit 1)
    if [[ "$(${impureXcodeLocation}/Contents/Developer/usr/bin/xcodebuild -version)" != "Xcode ${version}"* ]]; then
      echo "$(${impureXcodeLocation}/Contents/Developer/usr/bin/xcodebuild -version) was found. But Xcode ${version} was required. Please update your Xcode via the AppStore and retry";
      exit 1;
    fi
  '';

  src = "${impureSdkPath}";

  installPhase = ''
    cd MacOSX${osxVersion}.sdk
    mkdir -p "$out/share/sysroot" "$out/bin"
    cp -a * "$out/share/sysroot/"

    ln -s "${impureXcodeLocation}/Contents/Developer/usr/bin/xcodebuild" "$out/bin/xcodebuild"

    mkdir -p "$toolchain"
    cp -R "${impureXcodeLocation}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/"* $toolchain
    rm -r "$toolchain/share/"*
  '';

  meta = {
    homepage = "https://developer.apple.com/downloads/";
    description = "Apple's XCode SDK";
    license = stdenv.lib.licenses.unfree;
  };
}
