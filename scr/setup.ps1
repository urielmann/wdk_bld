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
