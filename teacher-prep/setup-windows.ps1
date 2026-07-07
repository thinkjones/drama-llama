# Camp Drama Llama - Windows prep (run in PowerShell AS ADMINISTRATOR).
#
# This installs WSL + Ubuntu, which gives every machine the Linux terminal the
# kids use in all three activities. After this finishes and you REBOOT, open
# Ubuntu once to create a username/password, then run teacher-prep/setup-wsl.sh
# inside Ubuntu to install the rest.
#
# Usage:
#   1. Click Start, type "PowerShell", right-click -> "Run as administrator".
#   2. If scripts are blocked, run:  Set-ExecutionPolicy -Scope Process Bypass
#   3. Run:  .\setup-windows.ps1

Write-Host "==> Installing WSL + Ubuntu..." -ForegroundColor Cyan

# 'wsl --install' enables WSL, the virtual machine platform, and installs
# Ubuntu by default. Works on Windows 10 (2004+) and Windows 11.
wsl --install -d Ubuntu

Write-Host ""
Write-Host "✔ WSL install command finished." -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. REBOOT the computer now."
Write-Host "  2. After reboot, Ubuntu opens automatically (or open it from Start)."
Write-Host "     Create a username and password when asked - write them down!"
Write-Host "  3. Inside the Ubuntu window, run the Linux setup script:"
Write-Host "        bash ~/drama-llama/teacher-prep/setup-wsl.sh" -ForegroundColor White
Write-Host "     (or copy setup-wsl.sh into Ubuntu first if the repo isn't there yet)."
