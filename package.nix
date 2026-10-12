{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook4,
  glib,
  gtk3,
  gdk-pixbuf,
  cairo,
  pipewire,
  wayland,
  vulkan-loader,
  webkitgtk_4_1,
  libsoup_3,
  libx11,
  libxtst,
  libayatana-appindicator,
  gst_all_1,
  glib-networking,
  ffmpeg,
  tesseract,
  grim,
  gnome-screenshot,
  xdotool,
  xinput,
  wlr-randr,
  wf-recorder,
  xrandr,
  xdpyinfo,
  xdg-utils,
  pulseaudio,
  wireplumber,
  fontconfig,
  pciutils,
}:

let
  gstreamerPlugins = with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
    pipewire
  ];
  runtimePrograms = [
    ffmpeg
    tesseract
    grim
    gnome-screenshot
    xdotool
    xinput
    wlr-randr
    wf-recorder
    xrandr
    xdpyinfo
    xdg-utils
    pulseaudio
    pipewire
    wireplumber
    fontconfig
    pciutils
    gst_all_1.gstreamer
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "screenix-bin";
  version = "1.8.3";

  src = fetchurl {
    url = "https://github.com/mathisdev7/screenix-releases/releases/download/v${finalAttrs.version}/Screenix_${finalAttrs.version}_amd64.deb";
    sha256 = "ea28cbe604f41d9ffa31d5e6d625d8f14c3b0fc6ba4f077919dbb6a7ad8f2a48";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook4
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    glib
    gtk3
    gdk-pixbuf
    cairo
    pipewire
    wayland
    vulkan-loader
    webkitgtk_4_1
    libsoup_3
    libx11
    libxtst
    libayatana-appindicator
    glib-networking
  ] ++ gstreamerPlugins;

  runtimeDependencies = [
    vulkan-loader
    libayatana-appindicator
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -a usr/. "$out/"
    substituteInPlace "$out/share/applications/Screenix.desktop" \
      --replace-fail "Icon=screenix-gui" "Icon=$out/share/icons/hicolor/128x128/apps/screenix-gui.png"
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath runtimePrograms}
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstreamerPlugins}
    )
  '';

  meta = {
    description = "Screen recorder with zoom effects and camera overlays";
    homepage = "https://screenix.studio";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "screenix-gui";
    platforms = [ "x86_64-linux" ];
  };
})
