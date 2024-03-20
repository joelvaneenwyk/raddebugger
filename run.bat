@echo off & goto:$Main

:Clear
    set "_build="
    set "_error="
    set "_exe="
    set "_inc="
    set "_root="
    set "_var="
    set "__DOTNET_ADD_64BIT="
    set "__DOTNET_PREFERRED_BITNESS="
    set "__VSCMD_PREINIT_PATH="
    set "release="
    set "raddbg="
    set "msvc="
    set "link_dll="
    set "net="
    set "INCLUDE="
    set "gfx="
    set "LINES="
    set "clink_dummy_capture_env="
    set "LIB="
    set "Ehsc="
    set "cl_obj="
    set "cl_link="
    set "cl_common="
    set "clang_out="
    set "cl="
    set "clang="
exit /b 0

:$Main
setlocal EnableDelayedExpansion
    call :Clear

    set "_vcvarsall=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
    if not exist "!_vcvarsall!" set "_vcvarsall=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat"
    if not exist "!_vcvarsall!" set "_vcvarsall=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"
    if not exist "!_vcvarsall!" goto:$MainDone

    call "!_vcvarsall!" x64
    call "%~dp0build.bat" raddbg              msvc    debug
    if errorlevel 1 goto:$MainDone
    call "%~dp0build.bat" raddbg_from_pdb     msvc    debug
    if errorlevel 1 goto:$MainDone
    call "%~dp0build.bat" raddbg_from_dwarf   msvc    debug
    if errorlevel 1 goto:$MainDone
    call "%~dp0build.bat" raddbg              clang   debug
    if errorlevel 1 goto:$MainDone
    call "%~dp0build.bat" raddbg_from_pdb     clang   debug
    if errorlevel 1 goto:$MainDone
    call "%~dp0build.bat" raddbg_from_dwarf   clang   debug
    if errorlevel 1 goto:$MainDone

    :$MainError
    set _error=%errorlevel%
    echo [ERROR] Failed to build projects with '!_error!' return code.
    goto:$MainDone

    :$MainDone
endlocal
call :Clear
exit /b %errorlevel%
