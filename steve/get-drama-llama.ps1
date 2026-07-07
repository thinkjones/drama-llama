# Camp Drama Llama - one-step downloader.
# Installs Git (if needed) and downloads this repo to your home folder:
#   %USERPROFILE%\drama-llama   (e.g. C:\Users\<you>\drama-llama)
#
# EASIEST WAY TO RUN (paste into PowerShell, no download needed):
#   irm https://raw.githubusercontent.com/thinkjones/drama-llama/main/steve/get-drama-llama.ps1 | iex
#
# Or, if you already have this file:
#   1. Start -> type "PowerShell" -> Enter
#   2. If scripts are blocked:  Set-ExecutionPolicy -Scope Process Bypass
#   3. Run:  .\get-drama-llama.ps1

$repoUrl = 'https://github.com/thinkjones/drama-llama.git'
$target  = Join-Path $HOME 'drama-llama'

function Find-Git {
    $cmd = Get-Command git -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $paths = @(
        "$env:ProgramFiles\Git\cmd\git.exe",
        "${env:ProgramFiles(x86)}\Git\cmd\git.exe",
        "$env:LOCALAPPDATA\Programs\Git\cmd\git.exe"
    )
    foreach ($p in $paths) { if (Test-Path $p) { return $p } }
    return $null
}

# --- 1. Make sure Git is installed ----------------------------------------
Write-Host "`n==> Checking for Git..." -ForegroundColor Cyan
$git = Find-Git
if (-not $git) {
    Write-Host "  Git not found - installing it with winget..." -ForegroundColor Yellow
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "  winget isn't available. Install Git from https://git-scm.com/download/win, then re-run." -ForegroundColor Red
        return
    }
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements -h
    $git = Find-Git
    if (-not $git) {
        Write-Host "`n  Git was installed but isn't on PATH yet." -ForegroundColor Yellow
        Write-Host "  Close this window, open a NEW PowerShell, and run this again." -ForegroundColor Yellow
        return
    }
}
Write-Host "  Using Git: $git" -ForegroundColor Green

# --- 2. Download (or update) the repo -------------------------------------
Write-Host "==> Downloading the workshop files to $target ..." -ForegroundColor Cyan
if (Test-Path (Join-Path $target '.git')) {
    & $git -C $target pull --ff-only
    Write-Host "  Updated your existing copy." -ForegroundColor Green
} elseif (Test-Path $target) {
    Write-Host "  '$target' already exists but isn't a git repo. Rename/move it and re-run." -ForegroundColor Red
    return
} else {
    & $git clone $repoUrl $target
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Clone failed. Check your internet connection and try again." -ForegroundColor Red
        return
    }
    Write-Host "  Downloaded to $target" -ForegroundColor Green
}

# --- 3. Next steps ---------------------------------------------------------
Write-Host "`n[OK] All set! Your files are at $target" -ForegroundColor Green
Write-Host ""
Write-Host "Next, for the Minecraft mod activity:" -ForegroundColor Yellow
Write-Host "  cd `$HOME\drama-llama\steve"
Write-Host "  # then follow CHEATSHEET.md   (build: .\gradlew.bat build)"
