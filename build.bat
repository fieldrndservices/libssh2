if not exist "build32\" mkdir build32 
pushd build32
cmake -G"Visual Studio 15 2017" -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLE=OFF -DBUILD_TESTING=OFF -DBUILD_DOCS=OFF -DCRYPTO_BACKEND=OpenSSL -DOPENSSL_ROOT_DIR="C:\Program Files (x86)\OpenSSL\" .. 
popd
if not exist "build64\" mkdir build64 
pushd build64
cmake -G "Visual Studio 15 2017 Win64" -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLE=OFF -DBUILD_TESTING=OFF -DBUILD_DOCS=OFF -DCRYPTO_BACKEND=OpenSSL -DOPENSSL_ROOT_DIR="C:\Program Files\OpenSSL" .. 
popd
cmake --build build32 --config Release
cmake --build build64 --config Release
pushd build64 & pushd src & pushd Release
if exist "labssh2-x64.dll" del "labssh2-x64.dll"
ren labssh2.dll labssh2-x64.dll
popd & popd & popd
