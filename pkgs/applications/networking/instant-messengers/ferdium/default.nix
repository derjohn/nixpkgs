{ lib, mkFranzDerivation, fetchurl, xorg, xdg-utils, buildEnv, writeShellScriptBin }:

let
  mkFranzDerivation' = mkFranzDerivation.override {
    xdg-utils = buildEnv {
      name = "xdg-utils-for-ferdi";
      paths = [
        xdg-utils
        (lib.hiPrio (writeShellScriptBin "xdg-open" ''
          unset GDK_BACKEND
          exec ${xdg-utils}/bin/xdg-open "$@"
        ''))
      ];
    };
  };
in
mkFranzDerivation' rec {
  pname = "ferdium";
  name = "Ferdium";
  version = "6.0.0-nightly.73";
  src = fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/ferdium_${version}_amd64.deb";
      sha256 = "sha256-t7LkHwGH0/whYso4Mz/ziQjdO1mCniflYTKr8Yfa4S0=";
  };

  extraBuildInputs = [ xorg.libxshmfence ];
  meta = with lib; {
    description = "Combine your favorite messaging services into one application";
    homepage = "https://ferdium.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco derjohn ma27 ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
