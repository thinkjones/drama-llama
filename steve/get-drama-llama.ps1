# Camp Drama Llama - one-step Windows setup for the Minecraft mod activity.
# Installs Git (if needed), Java 17 (if needed), downloads this repo, sets up
# the Minecraft/Forge gradle files, and installs the `steve` helper command.
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
$steveDir = Join-Path $target 'steve'

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

function Install-Git {
    Write-Host "  Git not found - installing it with winget..." -ForegroundColor Yellow
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "  winget isn't available. Install Git from https://git-scm.com/download/win, then re-run." -ForegroundColor Red
        return $null
    }
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements -h
    return Find-Git
}

function Find-Java {
    $cmd = Get-Command java -ErrorAction SilentlyContinue
    if ($cmd) {
        $ver = & $cmd.Source -version 2>&1 | Select-Object -First 1
        if ($ver -match '"17[\._]') { return $cmd.Source }
    }
    $patterns = @(
        "$env:ProgramFiles\Eclipse Adoptium\jdk-17*\bin\java.exe",
        "$env:ProgramFiles\Microsoft\jdk-17*\bin\java.exe",
        "$env:ProgramFiles\Java\jdk-17*\bin\java.exe",
        "${env:ProgramFiles(x86)}\Eclipse Adoptium\jdk-17*\bin\java.exe",
        "${env:ProgramFiles(x86)}\Microsoft\jdk-17*\bin\java.exe",
        "${env:ProgramFiles(x86)}\Java\jdk-17*\bin\java.exe"
    )
    foreach ($pat in $patterns) {
        $found = Get-Item $pat -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) { return $found.FullName }
    }
    return $null
}

function Install-Java {
    Write-Host "  Java 17 not found - installing it with winget..." -ForegroundColor Yellow
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "  winget isn't available. Install Java 17 from https://adoptium.net, then re-run." -ForegroundColor Red
        return $null
    }
    # Try Microsoft OpenJDK 17 first, then Eclipse Temurin 17.
    $packages = @('Microsoft.OpenJDK.17', 'EclipseAdoptium.Temurin.17.JDK')
    foreach ($pkg in $packages) {
        Write-Host "  Trying $pkg ..." -ForegroundColor Yellow
        winget install --id $pkg -e --accept-source-agreements --accept-package-agreements -h
        if ($LASTEXITCODE -eq 0) { break }
    }
    return Find-Java
}

function Refresh-Path {
    # Reload the user PATH from the registry into this PowerShell session.
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $env:Path = ($userPath, $machinePath) -join ';'
}

function Add-PathEntry {
    param([string]$dir)
    Refresh-Path
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $parts = $userPath -split ';' | Where-Object { $_ -and $_ -ne $dir }
    if ($parts -notcontains $dir) {
        $newPath = ($parts + $dir) -join ';'
        [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
        Refresh-Path
        Write-Host "  Added $dir to your PATH." -ForegroundColor Green
    } else {
        Write-Host "  $dir is already on your PATH." -ForegroundColor Green
    }
}

function Write-SteveCommand {
    # The .cmd wrapper lets `steve` work from PowerShell, cmd, and Win+R.
    $cmdPath = Join-Path $steveDir 'steve.cmd'
    $content = "@echo off`r`npowershell -NoProfile -ExecutionPolicy Bypass -File `"%~dp0steve-helper.ps1`" %*"
    Set-Content -Path $cmdPath -Value $content -Encoding ASCII -Force
    Write-Host "  Created $cmdPath" -ForegroundColor Green
}

function Invoke-GradleSetup {
    $gradlew = Join-Path $steveDir 'gradlew.bat'
    if (-not (Test-Path $gradlew)) {
        Write-Host "  gradlew.bat not found; skipping gradle setup." -ForegroundColor Yellow
        return
    }
    Write-Host "`n==> Running first-time Minecraft/Forge gradle build (this may take 5-15 minutes) ..." -ForegroundColor Cyan
    Push-Location $steveDir
    try {
        & $gradlew build
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  Gradle build had an error. Don't worry - run 'steve build' later to try again." -ForegroundColor Yellow
        } else {
            Write-Host "  Gradle build is ready and your mod jar is in build\libs\." -ForegroundColor Green
        }
    } finally {
        Pop-Location
    }
}

# --- 1. Make sure Git is installed ----------------------------------------
Write-Host "`n==> Checking for Git..." -ForegroundColor Cyan
$git = Find-Git
if (-not $git) {
    Install-Git | Out-Null
    Refresh-Path
    $git = Find-Git
}
if (-not $git) {
    Write-Host "`n  Git could not be installed automatically." -ForegroundColor Red
    return
}
Write-Host "  Using Git: $git" -ForegroundColor Green

# --- 2. Make sure Java 17 is installed ------------------------------------
Write-Host "`n==> Checking for Java 17..." -ForegroundColor Cyan
$java = Find-Java
if (-not $java) {
    Install-Java | Out-Null
    Refresh-Path
    $java = Find-Java
}
if (-not $java) {
    Write-Host "`n  Java 17 could not be installed automatically." -ForegroundColor Red
    return
}
Write-Host "  Using Java: $java" -ForegroundColor Green

# --- 3. Download (or update) the repo -------------------------------------
Write-Host "`n==> Downloading the workshop files to $target ..." -ForegroundColor Cyan
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

# --- 4. Install the `steve` helper command --------------------------------
Write-Host "`n==> Installing the 'steve' helper command..." -ForegroundColor Cyan
Write-SteveCommand
Add-PathEntry -dir $steveDir

# --- 5. First-time gradle setup -------------------------------------------
Invoke-GradleSetup

# --- 6. Done ---------------------------------------------------------------
Write-Host "`n[OK] All set! Your files are at $target" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Open a NEW PowerShell window (so the new 'steve' command is ready)."
Write-Host "  2. Type:  steve"
Write-Host "  3. Or jump straight in:  cd `$HOME\drama-llama\steve"
