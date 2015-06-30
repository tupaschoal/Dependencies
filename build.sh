#uses glob and local to separate where to extract files in the OpenRCT2 during pre-build

BASEDIR=`pwd`/`dirname $0`

mkdir build 
mkdir build/local
mkdir build/glob
mkdir build/glob/include
mkdir build/glob/lib
mkdir RCTBUILD
cp -ai ./src/argparse ./build/local
cp -ai ./src/cutest ./build/local
cp -ai ./src/libspeex ./build/local
cp -ai ./src/lodepng ./build/local

#build openssl for mingw
pushd ./src/openssl
	perl Configure mingw no-shared no-asm --cross-compile-prefix=i686-w64-mingw32- --prefix=$BASEDIR/RCTBUILD
	make depend
	make
	make install
popd

#build libcurl for mingw
pushd ./src/curl
	./configure --build=mingw32 --host=i686-w64-mingw32 --target=i686-w64-mingw32 --with-ssl=$BASEDIR/RCTBUILD --with-ssl --disable-shared --disable-ldap --disable-ldaps --disable-rtsp --disable-zlib --prefix=$BASEDIR/RCTBUILD
	make
	make install-strip
popd

#build jansson for minw
pushd ./src/jansson
	autoreconf -vi
	./configure --build=mingw32 --host=i686-w64-mingw32 --target=i686-w64-mingw32 --prefix=$BASEDIR/RCTBUILD
	make
	make install
popd

#copy global includes to the build
mkdir ./RCTBUILD/include/jansson
mv ./RCTBUILD/include/jansson*.h ./RCTBUILD/include/jansson/.
cp -ai ./RCTBUILD/lib ./build/glob/
cp -ai ./RCTBUILD/include ./build/glob/
