{ lib
, fetchurl
, appimageTools
, webkitgtk_4_1
, gtk3
, cairo
, gdk-pixbuf
, glib
, libsoup_3
, openssl
, alsa-lib
}:

let
  pname = "omniget";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/tonhowtf/omniget/releases/download/v${version}/omniget_${version}_amd64.AppImage";
    hash = "sha256-TYhtq/9duzD0u0c0mRbauVciEHWq1Pn/eBs1SV1PHBA=";
  };

  cliSrc = fetchurl {
    url = "https://github.com/tonhowtf/omniget/releases/download/v${version}/omniget-cli-${version}-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-0Wb/6UYbNRkIE81xAlCiKuqhWr72FIqtfZVMLQnOb2U=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    webkitgtk_4_1
    gtk3
    cairo
    gdk-pixbuf
    glib
    libsoup_3
    openssl
    alsa-lib
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/omniget.desktop $out/share/applications/omniget.desktop
    install -m 444 -D ${appimageContents}/omniget.png $out/share/icons/hicolor/32x32/apps/omniget.png
    substituteInPlace $out/share/applications/omniget.desktop \
      --replace-fail 'Exec=omniget' "Exec=$out/bin/omniget"
    cp -r ${appimageContents}/usr/share/icons $out/share/ 2>/dev/null || true

    tar -xzf ${cliSrc} -C $out/bin/
    chmod +x $out/bin/omniget-cli
  '';

  meta = with lib; {
    description = "Download Udemy and Hotmart courses, YouTube videos, music and books — 1,800+ sites";
    homepage = "https://github.com/tonhowtf/omniget";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "omniget";
  };
}
