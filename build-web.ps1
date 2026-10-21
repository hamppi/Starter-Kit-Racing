param([string]$Godot = "D:\Godot\bin\godot.windows.editor.x86_64.console.exe")
$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot
try {
    if (!(Test-Path $Godot)) { throw "Build the editor with D:\Godot\build-local.ps1 first, or pass -Godot." }
    if (!(Test-Path web-templates/release.zip)) { throw "The small custom template is missing. Rebuild it with Godot/misc/web_size/build-templates.sh; do not substitute the stock template." }
    & python tools/web-size/package_web.py . --verify-only
    if ($LASTEXITCODE) { throw "The custom template/profile needs to be rebuilt or restored." }
    New-Item -ItemType Directory -Force web-build | Out-Null
    New-Item -ItemType File -Force web-build/.gdignore | Out-Null
    & $Godot --headless --editor --path . --import
    if ($LASTEXITCODE) { throw "Godot asset import failed ($LASTEXITCODE)" }
    & $Godot --headless --path . --script res://tools/web-size/scan-project.gd -- res://.web-dependencies.json res://web-build-profile.gdbuild
    if ($LASTEXITCODE) { throw "The project needs features missing from its small template. Rebuild the custom template." }
    & $Godot --headless --path . --export-release Web web-build/index.html
    if ($LASTEXITCODE) { throw "Godot web export failed ($LASTEXITCODE)" }
    Copy-Item hub-web.json web-build/hub.json
    Copy-Item screenshots/screenshot.png web-build/hub-cover.png
    & python tools/web-size/package_web.py .
    if ($LASTEXITCODE) { throw "Web packaging failed ($LASTEXITCODE)" }
    Write-Host "Upload upload/game-build.zip to the platform. web-build is only the local Game Hub preview."
} finally { Pop-Location }

