# Modules ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Azure Active Directory
if ($host.Name -eq 'ConsoleHost') { Import-Module PSReadLine }
Import-Module AzureAD
Import-Module Az.Accounts
# Modules ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
# SHELL APPEARANCE AND BEHAVIORS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Get-Loc { Split-Path -leaf -path (Get-Location) }

function Prompt {
    $colorTable = @{
        "Reset"  = "`e[0m";
        "Red"    = "`e[31;1m";
        "Green"  = "`e[32;1m";
        "Yellow" = "`e[33;1m";
        "Grey"   = "`e[37;0m";
        "White"  = "`e[37;1m";
        "Invert" = "`e[7m";
        "RedBg"  = "`e[41m";
        "CyanBg" = "`e[46m";
    }

    $CurrentDir = (Get-Loc)

    switch ($CurrentDir -like "$($env:USERPROFILE)*") {
        $true {
            $CurrentDir = $CurrentDir.Replace($env:USERPROFILE)
            $CurrentDir = (Get-Loc)
            break
        }

        Default {
            break
        }
    }

    $promptText = "$($colorTable.Reset)$($colorTable.Yellow)[$env:COMPUTERNAME]:$($colorTable.Reset)$($colorTable.Green)[$($CurrentDir)]$($colorTable.Reset)$($promptKey)$($colorTable.Reset)"

    "${promptText} "
}

if ($Host.USI.RawUI.WindowTitle -like "*administrator*") {
    $Host.UI.RawUI.ForegroundColor = "Red"
}
# SHELL APPEARANCE AND BEHAVIORS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Import profile functions if the folder exists in the profile's directory
$profileFunctionsFolder = [System.IO.Path]::Combine($PSScriptRoot, "profile-functions")

switch (Test-Path -Path $profileFunctionsFolder) {
    $true {
        $profileFunctions = Get-ChildItem -Path $profileFunctionsFolder -Recurse | Where-Object { $PSItem.Extension -eq ".ps1" }
        $functionsBefore = Get-ChildItem -Path "Function:\"
        foreach ($func in $profileFunctions) {
            . "$($func.FullName)"
        }
        $functionsAfter = Get-ChildItem -Path "Function:\" | Where-Object { $PSItem -notin $functionsBefore }

        switch (($functionsAfter | Measure-Object).Count -gt 0) {
            $true {
                switch ($null -ne $env:WT_SESSION) {
                    $true {
                        Write-Output "$("`e[33;1m")Γ¥ùΓ¥ù WARNING Γ¥ùΓ¥ù"
                        Write-Output "Functions loaded through profile:"
                        Write-Output "$("`e[0m")"
                        break
                    }

                    Default {
                        Write-Warning "Functions loaded through profile -"
                        break
                    }
                }
                foreach ($loadedFunction in $functionsAfter) {
                    Write-Warning "* $($loadedFunction.Name)"
                }
                break
            }
        }
        break
    }
}
# ~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Quickly perform commands(s)                                                            
function Update-Powershell { iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI" }
function subl { &"${Env:ProgramFiles}\Sublime Text 3\sublime_text.exe" $args }
function Show-ShellVars { (dir variable:).where({ $_.options -match 'allscope' }) };
function Show-ENVVars { gci env:* | sort-object name; }
function Start-Electron($appName) { C:\ProgramData\chocolatey\lib\electron\tools\electron.exe $appName }
# ~~~~ SHORTCUTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Quickly naviagate to commonly used directories
$OnedrivePath = "$($Env:USERPROFILE)\OneDrive"
function Go-1drive { cd $OnedrivePath; }
function Go-myDocs { cd "$($OnedrivePath)\Documents" }
function Go-Workspace { cd "$($OnedrivePath)\Workspace" }
function Go-tmp { cd "$($OnedrivePath)\tmp" }
