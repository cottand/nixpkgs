{
  lib,
  stdenv,
  cmake,
  doxygen,
  fetchFromGitHub,
  gitUpdater,
  graphviz,
  gst_all_1,
  pkg-config,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pocketsphinx";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "cmusphinx";
    repo = "pocketsphinx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DUK3zPPtv+sQhC1dfJXDmwtt3UV6DGacb3mMQUpvVpk=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  buildInputs = [ gst_all_1.gstreamer ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_GSTREAMER" true)
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" "${placeholder "data"}/share")
  ];

  outputs = [
    "out"
    "data"
    "dev"
    "lib"
    "man"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Small speech recognizer";
    homepage = "https://github.com/cmusphinx/pocketsphinx";
    changelog = "https://github.com/cmusphinx/pocketsphinx/blob/v${finalAttrs.version}/NEWS";
    license = with licenses; [
      bsd2
      bsd3
      mit
    ];
    pkgConfigModules = [ "pocketsphinx" ];
    mainProgram = "pocketsphinx";
    maintainers = with maintainers; [ jopejoe1 ];
  };
})
