# Camp Drama Llama - Activity 3 (Minecraft mod) NATIVE WINDOWS setup.
#
# Activities 1 & 2 run in WSL/Ubuntu (see setup-wsl.sh). Activity 3 runs
# natively on Windows because Minecraft needs Windows to render the game.
#
# This installs, on the Windows side:
#   - JDK 17 (Temurin)      -> builds/runs the Forge mod
#   - Git for Windows       -> to clone the repo
#   - Claude Code (native)  -> the AI coding tool, in PowerShell
#   - VS Code (optional)    -> a friendly editor
#   - A Windows copy of the repo at %USERPROFILE%\drama-llama
#
# Minecraft: Java Edition + the Forge installer are OPTIONAL and only needed
# for "Way B" testing (playing the mod in real Minecraft). "Way A"
# (.\gradlew.bat runClient) needs neither. See steve\TESTING.md.
#
# Usage (PowerShell, normal user is fine; a couple installs may prompt for admin):
#   1. Start -> type "PowerShell" -> Enter
#   2. If scripts are blocked:  Set-ExecutionPolicy -Scope Process Bypass
#   3. Run:  .\setup-windows-modding.ps1

$ErrorActionPreference = 'Continue'
$repoUrl = 'https://github.com/thinkjones/drama-llama.git'
$target  = Join-Path $HOME 'drama-llama'
$failures = @()

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "  [!] $msg" -ForegroundColor Yellow; $script:failures += $msg }

# Requires winget (App Installer). Present on Windows 11 and updated Windows 10.
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Warn "winget not found. Install 'App Installer' from the Microsoft Store, then re-run. Skipping app installs."
} else {
    function Install-App($id, $name) {
        Step "Installing $name"
        winget list --id $id -e 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) { Ok "$name already installed"; return }
        winget install --id $id -e --accept-source-agreements --accept-package-agreements -h
        if ($LASTEXITCODE -eq 0) { Ok "$name installed" } else { Warn "$name install failed (exit $LASTEXITCODE)" }
    }

    Install-App 'EclipseAdoptium.Temurin.17.JDK' 'JDK 17 (Temurin)'
    Install-App 'Git.Git'                         'Git for Windows'
    Install-App 'Microsoft.VisualStudioCode'      'VS Code (optional editor)'
}

# --- Claude Code (native Windows installer) --------------------------------
Step "Installing Claude Code (native Windows)"
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Ok "Claude Code already installed"
} else {
    try {
        Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
        Ok "Claude Code installed (open a new terminal to use 'claude')"
    } catch {
        Warn "Claude Code install failed: $($_.Exception.Message)"
    }
}

# --- Windows copy of the repo ----------------------------------------------
Step "Setting up the repo at $target"
if (Test-Path (Join-Path $target '.git')) {
    Ok "Repo already at $target - pulling latest"
    git -C $target pull --ff-only 2>$null
} elseif (Test-Path $target) {
    Warn "$target exists but is not a git repo - leaving it alone"
} else {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone $repoUrl $target
        if ($LASTEXITCODE -eq 0) { Ok "Repo cloned to $target" } else { Warn "git clone failed - clone it manually" }
    } else {
        Warn "git not on PATH yet (open a new terminal after install, then re-run to clone)"
    }
}

# --- Summary ----------------------------------------------------------------
Write-Host ""
if ($failures.Count -eq 0) {
    Write-Host "Camp Drama Llama: Activity 3 (Windows) is ready!" -ForegroundColor Green
} else {
    Write-Host "Finished with $($failures.Count) item(s) needing attention:" -ForegroundColor Yellow
    $failures | ForEach-Object { Write-Host "   - $_" }
}
Write-Host ""
Write-Host "NEXT (in a NEW PowerShell window so PATH refreshes):" -ForegroundColor Yellow
Write-Host "  cd `$HOME\drama-llama\steve"
Write-Host "  java -version        # should say 17"
Write-Host "  claude               # log in once, then /exit"
Write-Host "  .\gradlew.bat build  # first build downloads Forge (5-15 min)"
Write-Host "  .\gradlew.bat runClient   # launch practice Minecraft (Way A)"
Write-Host ""
Write-Host "For 'Way B' (real Minecraft), see steve\TESTING.md." -ForegroundColor Yellow
