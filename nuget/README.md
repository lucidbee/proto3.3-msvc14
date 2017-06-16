## Packaging Google Protobuf for Nuget

NOTE for msvs 2015
- If you need to rebuild, note that there is no remove/uninstall capability or
  command outside of visual studio nuget package manager.  You must manually 
  remove the version under <home_dir>/.nuget and also delete the version under 
  brain/packages or you cannot install (unless there is a new version number). 

- BuildAndWriteNugetPackage.ps1 reports success always. Check that the libs are built.

- cmake of the tests did not work, caused failure, I deleted the run command.
  (will probably work if you run autogen.sh to download gmock)

- The msvc 2015 compiler defaults to /MT (static linking to the runtime library)
  which is in conflict with what inkingc expects resulting in linker errors. 
  (In older versions these errors were not reported.) Thus I had to add 
  /MD (DLL runtime library) to the protobuf/cmake dir cmake scripts.
  nuget protobuf.autopkg so I deleted the option in protobuf/cmake dir.

- the debug libs were build with the 'd' suffix. That does not sync with the
  nuget protobuf.autopkg so I deleted the option in protobuf/cmake dir.

- coapp tools are no longer maintained though they work for now.
  To get the xml files for plain nuget run Write-NuGetPackage with 
  -NoClean option

To create a nuget package for the Google C++ Protocol Buffer Library:

* Install the CoApp tools: http://downloads.coapp.org/files/Development.CoApp.Tools.Powershell.msi
* Install VS 2015.
* Run the BuildAndWriteNugetPackage.ps1 PS script from this folder.

This will create a nuget package for Google Test that can be used from VS or CMake. CMake usage example:

In PS execute:
```PowerShell
PS> nuget install bonsai.protobuf -ExcludeVersion
```
    
Then in your CMakeLists.txt:
```CMake
cmake_minimum_required(VERSION 2.8.12)

project(test_protobuf)

# make sure CMake finds the nuget installed package
find_package(protobuf REQUIRED)

add_executable(test_protobuf main.cpp)

# protobuf libraries are automatically mapped to the good arch/VS version/linkage combination
target_link_libraries(test_gtest ${gtest_LIBRARIES})
target_include_directories(test_gtest PRIVATE ${gtest_INCLUDE_DIR})

# copy the DLL to the output folder if desired.
if (MSVC AND COMMAND gtest_copy_shared_libs AND NOT gtest_STATIC)
  target_copy_shared_libs(test_gtest ${gtest_LIBRARIES})
endif ()
```

Special thanks to https://github.com/willyd for the gflags example.
