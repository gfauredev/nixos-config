{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  glibc,
  stdenv,
  glib,
  libsecret,
  xdg-utils,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  version = "0.9.0";

  src = fetchurl {
    url = "https://proton.me/download/drive/cli/${finalAttrs.version}/linux-x64/proton-drive";
    hash = "sha512-NTMCW6aa4RK2Tj4B+8wa0GiBNqQEP2z2pyiGln2F/c2ewjVHnC4RMXFhS+UiW/upNCdQmgXKWqYHHZJPp+kcqA==";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  # The executable is a Bun standalone binary: the JS bundle is embedded in the
  # file, so stripping would destroy it.
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    glibc
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/libexec/proton-drive-cli/proton-drive

    # Bun.secrets dlopen()s libsecret at runtime (OS keychain credential store),
    # and `auth login` spawns xdg-open to open the browser.
    makeWrapper $out/libexec/proton-drive-cli/proton-drive $out/bin/proton-drive \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libsecret
          glib
        ]
      } \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$TMPDIR $out/bin/proton-drive version
    runHook postInstallCheck
  '';

  meta = {
    description = "Command-line interface for Proton Drive";
    homepage = "https://proton.me/download/drive/cli/index.html";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "proton-drive";
  };
})
