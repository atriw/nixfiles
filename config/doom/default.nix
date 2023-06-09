{
  version ? "dev",
  lib,
  stdenv,
  emacs,
}:
stdenv.mkDerivation {
  pname = "emacs-config";
  inherit version;
  src = lib.sourceByRegex ./. [".*themes.*" "config.org" "init.el" "packages.el"];

  buildInputs = [emacs];

  buildPhase = ''
    cp -r $src/* .
    # Tangle org files
    emacs --batch -Q \
      -l org \
      config.org \
      -f org-babel-tangle
  '';

  dontUnpack = true;

  installPhase = ''
    install -D -t $out *.el
    cp -r $src/themes $out
  '';
}
