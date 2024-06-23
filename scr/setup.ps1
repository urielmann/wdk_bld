#
# @file wdk_bld/scr/setup.ps1
# @brief Set up build machine
#
# @copyright (C) 2024 Uriel Mann (abba.mann@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sub-license, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

param(
    [string]$vs_ver,
    [string]$arch,
    [string]$wdk_ver,
    [string]$spectre = '-vcvars_spectre_libs=spectre',
    [string]$toolset = '-vcvars_ver=14.0',
    [string]$plat_type = ''
)

Write-Output "Params: $vs_ver, $arch, $wdk_ver, $spectre, $toolset, $plat_type"

$scus = ( "BuildTools", "Community", "Professional", "Enterprise" )
$wdks = @{
  '7.1.0'                    = 'https://www.microsoft.com/download/confirmation.aspx?id=11800'; # Windows 7; 7.1.0

  '8.59.29757'               = 'https://go.microsoft.com/fwlink/p/?LinkID=324284'; # Windows 8.0
  'Windows 8.0'              = 'https://go.microsoft.com/fwlink/p/?LinkID=324284'; # 8.59.29757

  '10.1.14393.0'             = 'https://go.microsoft.com/fwlink/p/?LinkId=526733'; # Windows 10, version 1607
  'Windows 10, version 1607' = 'https://go.microsoft.com/fwlink/p/?LinkId=526733'; # 10.1.14393.0
  'EWDK 10.1.14393.0'        = 'https://go.microsoft.com/fwlink/p/?LinkID=699461'; # EWDK for Windows 10, version 1607 with Visual C++ Build Tools 2015

  '10.1.15063.0'             = 'https://go.microsoft.com/fwlink/p/?LinkID=845980'; # Windows 10, version 1703
  'Windows 10, version 1703' = 'https://go.microsoft.com/fwlink/p/?LinkID=845980'; # 10.1.15063.0
  'EWDK 10.1.15063.0'        = 'https://go.microsoft.com/fwlink/p/?LinkID=846038'; # EWDK for Windows 10, version 1703 with Visual C++ Build Tools 2015

  '10.1.16299.15'            = 'https://go.microsoft.com/fwlink/p/?linkid=859232'; # Windows 10, version 1709
  'Windows 10, version 1709' = 'https://go.microsoft.com/fwlink/p/?linkid=859232'; # 10.1.16299.15
  'EWDK 10.1.16299.15'       = 'https://go.microsoft.com/fwlink/?linkid=870959';   # EWDK for Visual Studio with Build Tools 15.6

  '10.1.17134.1'             = 'https://go.microsoft.com/fwlink/?linkid=873060';   # Windows 10, version 1803
  'Windows 10, version 1803' = 'https://go.microsoft.com/fwlink/?linkid=873060';   # 10.1.17134.1
  'EWDK 10.1.17134.1'        = 'https://go.microsoft.com/fwlink/?linkid=2008688';  # EWDK for Windows 10, version 1803 with Visual Studio Build Tools 15.7

  '10.1.17763.1'             = 'https://go.microsoft.com/fwlink/?linkid=2026156';  # Windows 10, version 1809
  'Windows 10, version 1809' = 'https://go.microsoft.com/fwlink/?linkid=2026156';  # 10.1.17763.1
  'EWDK 10.1.17763.1'        = 'https://go.microsoft.com/fwlink/?linkid=2070246'; # EWDK for Windows 10, version 1809 with Visual Studio Build Tools 15.8.9

  '10.1.18362.1'             = 'https://go.microsoft.com/fwlink/?linkid=2085767';  # Windows 10, version 1903
  'Windows 10, version 1903' = 'https://go.microsoft.com/fwlink/?linkid=2085767';  # 10.1.18362.1
  'EWDK 10.1.18362.1'        = 'https://go.microsoft.com/fwlink/p/?linkid=2086136'; # EWDK for Windows 10, version 1903 with Visual Studio Build Tools 16.0

  '10.1.19041.685'           = 'https://go.microsoft.com/fwlink/?linkid=2128854';  # Windows 10, version 2004
  'Windows 10, version 2004' = 'https://go.microsoft.com/fwlink/?linkid=2128854';  # 10.1.19041.685
  'EWDK 10.1.19041.685'      = 'https://go.microsoft.com/fwlink/p/?linkid=2128902'; # EWDK for Windows 10, version 2004 with Visual Studio Build Tools 16.7

  '10.1.20348.1'             = 'https://go.microsoft.com/fwlink/?linkid=2164149';  # Windows Server 2022
  'Windows Server 2022'      = 'https://go.microsoft.com/fwlink/?linkid=2164149';  # 10.1.20348.1
  'EWDK 10.1.20348.1'        = 'https://go.microsoft.com/fwlink/?linkid=2271957'; # Windows 11, version 24H2 EWDK (released May 22, 2024) with Visual Studio Buildtools 17.8.6

  '10.1.22000.1'             = 'https://go.microsoft.com/fwlink/?linkid=2166289';  # Windows 11, version 21H2
  'Windows 11, version 21H2' = 'https://go.microsoft.com/fwlink/?linkid=2166289';  # 10.1.22000.1
  'EWDK 10.1.22000.1'        = 'https://go.microsoft.com/fwlink/?linkid=2202360'; # Windows 11 EWDK with Visual Studio Build Tools 16.11.10

  '10.1.22621.382'           = 'https://go.microsoft.com/fwlink/?linkid=2196230';  # Windows 11, version 22H2
  'Windows 11, version 22H2' = 'https://go.microsoft.com/fwlink/?linkid=2196230';  # 10.1.22621.382
  '10.1.22621.2428'          = 'https://go.microsoft.com/fwlink/?linkid=2249371';  # Windows 11, Version 23H2
  'Windows 11, Version 23H2' = 'https://go.microsoft.com/fwlink/?linkid=2249371';  # 10.1.22621.2428
  'EWDK 10.1.22621.2428'     = 'https://go.microsoft.com/fwlink/?linkid=2249942'; # Windows 11, version 22H2 EWDK (released October 24, 2023) with Visual Studio Buildtools 17.1.5

  '10.1.26100.1'             = 'https://go.microsoft.com/fwlink/?linkid=2272234';  # Windows 11, Version 24H2
  'Windows 11, Version 24H2' = 'https://go.microsoft.com/fwlink/?linkid=2272234';  # 10.1.26100.1
  'EWDK 10.1.26100.1'        = 'https://go.microsoft.com/fwlink/?linkid=2271957'; # Windows 11, version 24H2 EWDK (released May 22, 2024) with Visual Studio Buildtools 17.8.6

  'Build Tools for Visual Studio 2017'          = 'https://aka.ms/vs/15/release/vs_buildtools.exe';
  'Remote Tools for Visual Studio 2017 (amd64)' = 'https://aka.ms/vs/15/release/RemoteTools.amd64ret.enu.exe';
  'Remote Tools for Visual Studio 2017 (arm64)' = 'https://aka.ms/vs/15/release/RemoteTools.arm64ret.enu.exe';
  'Remote Tools for Visual Studio 2017 (x86)'   = 'https://aka.ms/vs/15/release/RemoteTools.x86ret.enu.exe';

  'Build Tools for Visual Studio 2019'          = 'https://aka.ms/vs/16/release/vs_buildtools.exe';
  'Remote Tools for Visual Studio 2019 (amd64)' = 'https://aka.ms/vs/16/release/RemoteTools.amd64ret.enu.exe';
  'Remote Tools for Visual Studio 2019 (arm64)' = 'https://aka.ms/vs/16/release/RemoteTools.arm64ret.enu.exe';
  'Remote Tools for Visual Studio 2019 (x86)'   = 'https://aka.ms/vs/16/release/RemoteTools.x86ret.enu.exe';

  'Build Tools for Visual Studio 2022'          = 'https://aka.ms/vs/17/release/vs_BuildTools.exe';
  'Remote Tools for Visual Studio 2022 (amd64)' = 'https://aka.ms/vs/17/release/RemoteTools.amd64ret.enu.exe';
  'Remote Tools for Visual Studio 2022 (arm64)' = 'https://aka.ms/vs/17/release/RemoteTools.arm64ret.enu.exe';
  'Remote Tools for Visual Studio 2022 (x86)'   = 'https://aka.ms/vs/17/release/RemoteTools.x86ret.enu.exe';
}

Foreach ( $scu in $scus ) {
  $vcvarsall_bat = "C:\Program Files (x86)\Microsoft Visual Studio\2019\$scu\VC\Auxiliary\Build\vcvarsall.bat"
  Write-Output "Checking: $vcvarsall_bat"
  $exists = Test-Path $vcvarsall_bat
  if ( $exists -Eq $true ) {
    $out = $vcvarsall_bat
    Break
  }
  Write-Output "Missing: $vcvarsall_bat"
}
if ($out -Eq "") {
  Write-Error "Unable to set build environment"
  exit 1
}

Write-Output "Discovered: $out"
Write-Output 'Add-Content -Path $env:GITHUB_ENV -Value "setup_cmd=`"$out`""'
Add-Content -Path $env:GITHUB_ENV -Value "setup_cmd=`"$out`""

Write-Output "Download WDK ($wdk_ver)"
$result = Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=2128854 -OutFile $env:TEMP\wdksetup.exe -PassThru
if ($result.StatusCode -Ne 200) {
  Write-Error "Unable to download https://go.microsoft.com/fwlink/?linkid=2128854"
  exit 1
}

Write-Output "Install WDK ($wdk_ver)"
$result = Start-Process $env:TEMP\wdksetup.exe -ArgumentList '/silent' -Wait -PassThru
if ($result.ExitCode -Ne 0) {
  Write-Error "Unable to install"
  exit 1
}
Write-Output "$out is ready"
