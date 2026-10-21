param([string]$Godot = "D:\Godot\bin\godot.windows.editor.x86_64.console.exe")
$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot
try {
    if (!(Test-Path $Godot)) { throw "Build the editor with D:\Godot\build-local.ps1 first, or pass -Godot." }
    New-Item -ItemType Directory -Force web-build | Out-Null
    New-Item -ItemType File -Force web-build/.gdignore | Out-Null
    & $Godot --headless --editor --path . --import
    if ($LASTEXITCODE) { throw "Godot asset import failed ($LASTEXITCODE)" }
    & $Godot --headless --path . --export-release Web web-build/index.html
    if ($LASTEXITCODE) { throw "Godot web export failed ($LASTEXITCODE)" }
    Copy-Item hub-web.json web-build/hub.json
    Compress-Archive -Path web-build/* -DestinationPath game-build.zip -Force
    Write-Host "Built web-build/index.html and game-build.zip"
} finally { Pop-Location }

