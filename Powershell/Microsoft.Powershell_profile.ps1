Import-Module posh-git
Set-PSReadlineOption -BellStyle None

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $false

# function prompt  {
#     $realLEC = $LASTEXITCODE

#     $folder =  $(Split-Path -Leaf -Path $PWD.ProviderPath)
#     Write-Host("$env:UserName@$env:ComputerName") -ForegroundColor Green -NoNewline
#     Write-Host(':') -NoNewline
#     Write-Host("$folder") -NoNewline -ForegroundColor Cyan
#     Write-VcsStatus
#     $global:LASTEXITCODE = $realLEC
#     "> "
# }

function devcmd { & $env:comspec /k "C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\Common7\Tools\VsDevCmd.bat" }
function devpwsh { Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell f9b0d9ba -StartInPath $(Get-Location) -DevCmdArguments '-arch=x86 -no_logo'; }
function devpwsh64 { Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell f9b0d9ba -StartInPath $(Get-Location) -DevCmdArguments '-arch=x64 -no_logo'; }
function devcmd64 { & $env:comspec /k "C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64 }

. "$PSScriptRoot\Scripts\GhCompletion.ps1"

function devsandbox { start "E:\startSandbox.wsb" }

function windbg
{
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        [parameter(mandatory=$true, position=0)][string]$arch,
        [parameter(mandatory=$false, position=1, ValueFromRemainingArguments=$true)] $Remaining
    )
    Write-Host $Remaining
    Invoke-Expression "& `"E:\util\toolssw\$arch\windbg.exe`" $Remaining"
}

function mdv
{
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        [parameter(mandatory=$false, position=1, ValueFromRemainingArguments=$true)] $Remaining
    )
    Write-Host $Remaining
    Invoke-Expression "& `"E:\util\mdv.1.0.0-beta3.20607.2\tools\mdv.exe`" $Remaining"
}

function gflags {param ([string] $arch) &"E:\util\toolssw\$arch\gflags.exe" }

function rf-helix {
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        [parameter(mandatory=$true, position=0)][string]$helixBlurb,
        [parameter(mandatory=$true, position=1)][string]$path
    )
    $data = ConvertFrom-Json $helixBlurb;
    mkdir $path
    Invoke-Expression -Command $(runfo get-helix-payload --jobid $($data.HelixJobId) --workitems $($data.HelixWorkItemName) -o $path)
}

function repo { param ([string] $name) cd "E:\repos\$name" }
function mocks { param ([string] $name) cd "E:\mocks\$name" }
function xunit-report
{
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        [parameter(mandatory=$true, position=0)][string]$inputFile,
        [parameter(mandatory=$true, position=1)][string]$outputFile,
        [parameter(mandatory=$false, position=3)][bool]$show = $true

    )
    $inputFilePath = (gi $inputFile).FullName
    pushd E:\util\error_report\
    py -3 error_report.py --out $outputFile --in $inputFilePath
    popd
    if ($show)
    {
        Invoke-Item "E:\util\error_report\assets\$outputFile.html"
    }
}

function Set-Title {
    param(
        [string]
        $title
    )
    $Host.UI.RawUI.WindowTitle = $title
}

$GitPromptSettings.DefaultPromptPath.ForegroundColor = [System.ConsoleColor]::Cyan
$GitPromptSettings.DefaultPromptPrefix.Text = "$env:UserName@$env:ComputerName::"
$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [System.ConsoleColor]::Green

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
