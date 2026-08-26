{
  stdenv,
  lib,
  fetchFromCodeberg,
  pkg-config,
  lua5_4,

  ## used in pkgs.the_package_overrides {};
  foobarAttrs ? { },
}:
let
  inherit (lib) platforms;

  pname = "fetchit";
  version = "2026.08.12";
  src_data = {
    owner = "nzuum";
    repo = pname;
    rev = "da3f5cf58f";
    hash = "sha256-gT+zfJjFxgZcXlCR3crD4QuZlrb5Z9psvdUtAYUTHEo=";
  };
in
stdenv.mkDerivation {
  inherit
    pname
    version
    ;

  src = fetchFromCodeberg src_data;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    lua5_4
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  installPhase = ''
    make install PREFIX="$out"
    make install-config CONFIG_DST="$out/share/pkgit/config"
  '';

  meta = {
    description = "fastfetch alternative configurable in lua";
    homepage = "https://codeberg.org/${src_data.owner}/${src_data.repo}";
    platforms = platforms.linux;
    license = lib.licenses.bsd3;
  };
}
