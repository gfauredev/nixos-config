let
  pkgs = import <nixpkgs> { };
  python = pkgs.python3Full;
  # pyPkgs = with python.pkgs; [ venvShellHook ];
  lib-path = with pkgs; lib.makeLibraryPath [ libffi openssl stdenv.cc.cc ];
in with pkgs;
mkShell {
  packages = with python.pkgs; [ python venvShellHook ];

  buildInputs = [ readline libffi openssl git openssh rsync ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
    VENV=.venv

    if ! [ -d $VENV ]; then
      python -m venv $VENV
    fi
    source ./$VENV/bin/activate
    export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
    if [ -f ./requirements.txt ]; then
      pip install -r requirements.txt
    fi
  '';

  postShellHook = ''
    ln -sf ${python.sitePackages}/* ./.venv/lib/python3.*/site-packages
  '';
}
