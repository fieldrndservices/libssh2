if not exist "bin32\" mkdir bin32 
pushd bin32
cmake .. -DBUILD_SHARED_LIBS=ON
popd
if not exist "bin64\" mkdir bin64 
pushd bin64
cmake -G "Visual Studio 15 2017 Win64" .. -DBUILD_SHARED_LIBS=ON
popd
cmake --build bin32 --config Release
cmake --build bin64 --config Release
pushd bin32
pushd src
pushd Release
if exist "labssh2.dll" del "labssh2.dll"
ren libssh2.dll labssh2.dll
popd
popd
popd
pushd bin64
pushd src
pushd Release
if exist "labssh2-x64.dll" del "labssh2-x64.dll"
ren libssh2.dll labssh2-x64.dll
popd
popd
popd
