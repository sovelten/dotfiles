{ stdenv, fetchgit, cmake, xorg, pkgconfig, imlib2, lib, libXrandr, libpthreadstubs, libXau, libXdmcp, libXext}:

stdenv.mkDerivation {

  name = "wallpaperd";

  src = fetchgit {
    url = "https://github.com/pekdon/wallpaperd.git";
    rev = "8ca11bfb25993e11e4d7c582f788879f9337df87";
    sha256 = "07hx85dlalxavsksjz7bns4kyg0yi7q6hzipr1f4gazb4abnx5kp";
  };

  nativeBuildInputs = [ cmake pkgconfig xorg.libX11 imlib2 libXrandr libpthreadstubs libXau libXdmcp libXext ];
  buildInputs = [ xorg.libX11 imlib2 libXrandr libpthreadstubs libXau libXdmcp libXext];
 
  #builder = ./builder.sh;

  meta = with lib; {
    description = "Wallpaper daemon";
    homepage = "https://github.com/pekdon/wallpaperd"; 
    maintainers = [];
    license = licenses.mit;
    platforms = platforms.linux;
  };

}
