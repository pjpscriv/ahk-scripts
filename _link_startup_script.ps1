# Symlinks this repo's ahk_scripts.bat to the Windows Startup folder, creating
# the startup script from a default template first if it doesn't exist yet.
# Creating a symlink usually requires an elevated PowerShell session, unless
# Developer Mode is enabled in Windows Settings.

$RepoRoot = $PSScriptRoot
$StartupDir = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
$StartupScript = Join-Path $StartupDir "ahk_scripts.bat"
$LinkPath = Join-Path $RepoRoot "ahk_scripts.bat"

if (Test-Path $LinkPath) {
    Write-Host "Link already exists at $LinkPath"
    exit
}

if (-not (Test-Path $StartupScript)) {
    Write-Host "No startup script found, creating default at $StartupScript"
    $content = @"
@echo off
echo Running autohotkey scripts on startup

powerShell "$RepoRoot\extra_glyphs.ahk"
powerShell "$RepoRoot\new_txt_file_laptop.ahk"

echo Done!
timeout /T 4
exit
"@
    Set-Content -Path $StartupScript -Value $content
}

New-Item -ItemType SymbolicLink -Path $LinkPath -Target $StartupScript | Out-Null
Write-Host "Linked $LinkPath -> $StartupScript"
