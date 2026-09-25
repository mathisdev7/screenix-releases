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
  version = "1.7.10";

  src = fetchurl {
    url = "https://github.com/mathisdev7/screenix-releases/releases/download/v${finalAttrs.version}/Screenix_${finalAttrs.version}_amd64.deb";
    sha256 = "920fb9fa33d1d57469a928bc9416d9074f13460b48a3fb8833ed10c6faf1495d";
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
