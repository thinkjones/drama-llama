# Camp Drama Llama - full Windows setup (run in PowerShell).
#
# The WHOLE workshop runs on Windows (no WSL/Ubuntu). This prepares a machine
# for all three activities:
#   - Git                    -> download the workshop files
#   - Python 3               -> Activity 2 (Python)
#   - JDK 17 (Temurin)       -> Activity 3 (Minecraft mod) + sets JAVA_HOME
#   - VS Code                -> a friendly editor
#   - Claude Code (native)   -> the AI coding tool, in PowerShell
#   - This repo at %USERPROFILE%\drama-llama
#
# Minecraft: Java Edition + the Forge 1.20.1 installer are OPTIONAL, only for
# "Way B" testing (playing the mod in real Minecraft). This script checks
# whether they're installed and tells you. "Way A" (.\gradlew.bat runClient)
# needs neither. See steve\TESTING.md.
#
# Usage:
#   1. Start -> type "PowerShell" -> Enter
#   2. If scripts are blocked:  Set-ExecutionPolicy -Scope Process Bypass
#   3. Run:  .\setup-windows.ps1
#   4. IMPORTANT: open a NEW PowerShell window afterwards so PATH/JAVA_HOME apply.

$repoUrl  = 'https://github.com/thinkjones/drama-llama.git'
$target   = Join-Path $HOME 'drama-llama'
$failures = @()

function Step($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "  [OK] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [!] $m" -ForegroundColor Yellow; $script:failures += $m }

function Install-App($id, $name) {
    Step "Installing $name"
    winget list --id $id -e 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { Ok "$name already installed"; return }
    winget install --id $id -e --accept-source-agreements --accept-package-agreements -h
    if ($LASTEXITCODE -eq 0) { Ok "$name installed" } else { Warn "$name install failed (exit $LASTEXITCODE)" }
}

# Find the Temurin JDK 17 and set JAVA_HOME + PATH so gradlew works.
function Set-JavaHome {
    $roots = @("$env:ProgramFiles\Eclipse Adoptium", "${env:ProgramFiles(x86)}\Eclipse Adoptium")
    foreach ($r in $roots) {
        if (Test-Path $r) {
            $jdk = Get-ChildItem $r -Directory -Filter 'jdk-17*' -ErrorAction SilentlyContinue |
                   Sort-Object Name -Descending | Select-Object -First 1
            if ($jdk) {
                [Environment]::SetEnvironmentVariable('JAVA_HOME', $jdk.FullName, 'User')
                $env:JAVA_HOME = $jdk.FullName
                $bin = Join-Path $jdk.FullName 'bin'
                $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
                if ($userPath -notlike "*$bin*") {
                    [Environment]::SetEnvironmentVariable('Path', ($userPath.TrimEnd(';') + ';' + $bin), 'User')
                }
                if ($env:Path -notlike "*$bin*") { $env:Path = $env:Path.TrimEnd(';') + ';' + $bin }
                return $jdk.FullName
            }
        }
    }
    return $null
}

function Test-ForgeInstalled {
    $versions = Join-Path $env:APPDATA '.minecraft\versions'
    if (-not (Test-Path $versions)) { return $false }
    $hit = Get-ChildItem $versions -Directory -ErrorAction SilentlyContinue |
           Where-Object { $_.Name -match 'forge' -and $_.Name -match '1\.20\.1' }
    return [bool]$hit
}

# --- App installs ----------------------------------------------------------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Warn "winget not found. Install 'App Installer' from the Microsoft Store, then re-run. Skipping app installs."
} else {
    Install-App 'Git.Git'                    'Git for Windows'
    Install-App 'Python.Python.3.12'         'Python 3'
    Install-App 'EclipseAdoptium.Temurin.17.JDK' 'JDK 17 (Temurin)'
    Install-App 'Microsoft.VisualStudioCode' 'VS Code'
}

# --- JAVA_HOME -------------------------------------------------------------
Step "Setting JAVA_HOME (fixes '.\gradlew.bat' Java errors)"
$jh = Set-JavaHome
if ($jh) { Ok "JAVA_HOME = $jh" } else { Warn "Couldn't find a Temurin JDK 17 to point JAVA_HOME at (open a new terminal and re-run if you just installed it)" }

# --- Claude Code (native Windows) ------------------------------------------
Step "Installing Claude Code (native Windows)"
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Ok "Claude Code already installed"
} else {
    try { Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression; Ok "Claude Code installed" }
    catch { Warn "Claude Code install failed: $($_.Exception.Message)" }
}

# --- The workshop repo -----------------------------------------------------
Step "Downloading the repo to $target"
if (Test-Path (Join-Path $target '.git')) {
    Ok "Repo already present - pulling latest"
    git -C $target pull --ff-only 2>$null
} elseif (Test-Path $target) {
    Warn "$target exists but isn't a git repo - leaving it alone"
} elseif (Get-Command git -ErrorAction SilentlyContinue) {
    git clone $repoUrl $target
    if ($LASTEXITCODE -eq 0) { Ok "Cloned to $target" } else { Warn "git clone failed" }
} else {
    Warn "git not on PATH yet - open a NEW PowerShell and run this script again to clone"
}

# --- Minecraft / Forge readiness (for Way B) -------------------------------
Step "Checking real-Minecraft support (optional, for 'Way B' testing)"
if (Test-Path (Join-Path $env:APPDATA '.minecraft')) {
    if (Test-ForgeInstalled) {
        Ok "Minecraft + Forge 1.20.1 detected - Way B is ready"
    } else {
        Warn "Minecraft found, but no Forge 1.20.1. For Way B, install it from https://files.minecraftforge.net (pick 1.20.1 -> Install client). Way A still works without it."
    }
} else {
    Warn "No Minecraft install found. Way A (.\gradlew.bat runClient) still works. For Way B, install Minecraft: Java Edition + Forge 1.20.1. See steve\TESTING.md."
}

# --- Summary ---------------------------------------------------------------
Write-Host ""
if ($failures.Count -eq 0) {
    Write-Host "Camp Drama Llama: this machine is ready!" -ForegroundColor Green
} else {
    Write-Host "Finished with $($failures.Count) item(s) needing attention:" -ForegroundColor Yellow
    $failures | ForEach-Object { Write-Host "   - $_" }
}
Write-Host ""
Write-Host "NEXT - open a NEW PowerShell window (so PATH + JAVA_HOME take effect), then:" -ForegroundColor Yellow
Write-Host "  claude                       # log in once, then /exit"
Write-Host "  cd `$HOME\drama-llama\steve"
Write-Host "  java -version                # should say 17"
Write-Host "  .\gradlew.bat build          # first build downloads Forge (5-15 min)"
Write-Host "  .\gradlew.bat runClient      # launch practice Minecraft (Way A)"
