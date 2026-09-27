# derived from schembriaiden/helium-browser-nix-flake (MIT) - pls see LICENSES/helium-flake.md
{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "helium";
  version = "0.15.6.1";
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-OqXMEZOoFu6NZAozde3ApjNWcvivIItIyeG0HbADpDU=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/helium.desktop -t $out/share/applications
    sed -i 's|^Exec=.*|Exec=helium %U|' $out/share/applications/helium.desktop
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "private, fast, and honest web browser";
    homepage = "https://helium.computer";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
