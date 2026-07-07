# Steve - helper command for the Camp Drama Llama Minecraft mod.
# Run from any PowerShell window after setup.

$steveDir = $PSScriptRoot
$jarName  = 'agentarmor-1.0.0.jar'
$jarPath  = Join-Path $steveDir "build\libs\$jarName"
$modsDir  = "$env:APPDATA\.minecraft\mods"

function Show-Help {
    Write-Host ""
    Write-Host "🦙 Steve - your Camp Drama Llama Minecraft mod helper" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "This folder: " -NoNewline
    Write-Host $steveDir -ForegroundColor Yellow
    Write-Host ""

    Write-Host "HOW TO CHANGE THE MOD" -ForegroundColor Green
    Write-Host "  1. Make sure you are in this folder:  cd `$HOME\drama-llama\steve"
    Write-Host "  2. Start Claude Code:                claude"
    Write-Host "  3. Ask Claude to explain or change something, for example:"
    Write-Host "       - 'Make the Agent Armor protect more than diamond armor.'"
    Write-Host "       - 'Rename Agent Armor to Llama Armor everywhere.'"
    Write-Host "       - 'Build the Spy HQ out of gold blocks.'"
    Write-Host "       - 'Make the sign say AGENT ZONE instead.'"
    Write-Host ""

    Write-Host "HOW TO BUILD THE MOD" -ForegroundColor Green
    Write-Host "  steve build"
    Write-Host "  (Or run:  .\gradlew.bat build)"
    Write-Host "  Your mod file will appear at: build\libs\$jarName"
    Write-Host "  The first build downloads Minecraft + Forge and takes 5-15 minutes."
    Write-Host ""

    Write-Host "HOW TO TEST IN PRACTICE MINECRAFT (easiest, no account needed)" -ForegroundColor Green
    Write-Host "  steve run"
    Write-Host "  (Or run:  .\gradlew.bat runClient)"
    Write-Host "  When Minecraft opens: Singleplayer -> Create New World -> Create."
    Write-Host ""

    Write-Host "HOW TO INSTALL INTO REAL MINECRAFT (needs Minecraft Java + Forge 1.20.1)" -ForegroundColor Green
    Write-Host "  Official Minecraft Launcher:"
    Write-Host "    1. steve build"
    Write-Host "    2. steve install        (puts jar in %APPDATA%\.minecraft\mods)"
    Write-Host "    3. Open the Minecraft Launcher and pick the 'Forge 1.20.1' profile."
    Write-Host "    4. Play -> Create New World."
    Write-Host ""
    Write-Host "  CurseForge:"
    Write-Host "    1. steve build"
    Write-Host "    2. Make a Custom Profile with Minecraft 1.20.1 + Forge 47.x."
    Write-Host "    3. Right-click profile -> Open Folder -> copy the jar into mods\."
    Write-Host "    4. Play."
    Write-Host ""

    Write-Host "COMMANDS" -ForegroundColor Green
    Write-Host "  steve          show this help"
    Write-Host "  steve build    build the mod jar"
    Write-Host "  steve run      launch practice Minecraft with the mod"
    Write-Host "  steve install  copy the mod jar into your real Minecraft mods folder"
    Write-Host ""
}

function Invoke-Build {
    Push-Location $steveDir
    try {
        Write-Host "`n==> Building the mod..." -ForegroundColor Cyan
        .\gradlew.bat build
        if ($LASTEXITCODE -ne 0) {
            Write-Host "`nBuild failed. Copy the error and ask Claude Code for help." -ForegroundColor Red
        } else {
            Write-Host "`n[OK] Build complete!`n" -ForegroundColor Green
            Write-Host "Your mod jar is here:" -ForegroundColor Yellow
            Write-Host "  $jarPath" -ForegroundColor Yellow
        }
    } finally {
        Pop-Location
    }
}

function Invoke-Run {
    Push-Location $steveDir
    try {
        Write-Host "`n==> Launching practice Minecraft..." -ForegroundColor Cyan
        Write-Host "When it opens: Singleplayer -> Create New World -> Create.`n" -ForegroundColor Yellow
        .\gradlew.bat runClient
    } finally {
        Pop-Location
    }
}

function Invoke-Install {
    if (-not (Test-Path $jarPath)) {
        Write-Host "`nMod jar not found at $jarPath" -ForegroundColor Red
        Write-Host "Run 'steve build' first.`n" -ForegroundColor Yellow
        return
    }
    if (-not (Test-Path $modsDir)) {
        New-Item -ItemType Directory -Path $modsDir -Force | Out-Null
    }
    Copy-Item -Path $jarPath -Destination $modsDir -Force
    Write-Host "`n[OK] Copied $jarName to:" -ForegroundColor Green
    Write-Host "  $modsDir" -ForegroundColor Yellow
    Write-Host "`nOpen the Minecraft Launcher, choose the 'Forge 1.20.1' profile, and play.`n" -ForegroundColor Green
    Write-Host "Using CurseForge instead? See TESTING.md for the CurseForge mods folder.`n" -ForegroundColor DarkGray
}

# --- Main entry point --------------------------------------------------------
$arg = if ($args.Count -gt 0) { $args[0].ToLower() } else { 'help' }

switch ($arg) {
    'build'   { Invoke-Build }
    'run'     { Invoke-Run }
    'install' { Invoke-Install }
    'help'    { Show-Help }
    default   {
        Write-Host "Unknown command: $arg" -ForegroundColor Red
        Show-Help
    }
}
