# Use cmake to build versions of protobuf targetted at
# different CPU and library settings.
# Based on code written by https://github.com/willyd
#######################################################

function BuildPivot( $source_dir, $build_dir, $generator, $options ) {
    if(!(Test-Path -Path $build_dir )){
        mkdir $build_dir
    }

    pushd $build_dir
    & cmake -G $generator $options $source_dir
    cmake --build . --config Debug
    cmake --build . --config Release
    popd
}

$source_dir   = "$PSScriptRoot\..\cmake"

#######################################################
$build_dir = "./build/x64/v140/static"
$generator = "Visual Studio 14 2015 Win64"
$options = @("-DCMAKE_CXX_FLAGS_DEBUG='/D_DEBUG /MDd /Z7 /Ob0 /Od /RTC1'", "-DBUILD_SHARED_LIBS=OFF","-Dprotobuf_BUILD_TESTS=OFF")

BuildPivot $source_dir $build_dir $generator $options

$build_dir = "./build/x64/v140/dynamic"
$generator = "Visual Studio 14 2015 Win64"
$options = @("-DBUILD_SHARED_LIBS=ON","-Dprotobuf_BUILD_TESTS=OFF")

BuildPivot $source_dir $build_dir $generator $options

$build_dir = "./build/Win32/v140/static"
$generator = "Visual Studio 14 2015"
$options = @("-DCMAKE_CXX_FLAGS_DEBUG='/D_DEBUG /MDd /Z7 /Ob0 /Od /RTC1'", "-DBUILD_SHARED_LIBS=OFF","-Dprotobuf_BUILD_TESTS=OFF")

BuildPivot $source_dir $build_dir $generator $options

$build_dir = "./build/Win32/v140/dynamic"
$generator = "Visual Studio 14 2015"
$options = @("-DBUILD_SHARED_LIBS=ON","-Dprotobuf_BUILD_TESTS=OFF")

BuildPivot $source_dir $build_dir $generator $options

#######################################################

# Collect Includes
#######################################################
pushd "./build"
& "./x64/v140/static/extract_includes.bat"
popd
#######################################################

# NoClean leaves xml files on disc
#Write-NuGetPackage -NoClean -Package .\protobuf.autopkg
Write-NuGetPackage -Package .\protobuf.autopkg
