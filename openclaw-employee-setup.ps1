# =============================================================================
# OpenClaw Employee Setup Script for Windows
# Run this in PowerShell as Administrator on each employee laptop
# =============================================================================

param(
    [string]$EmployeeName = "employee",
    [string]$AdminPassword = "",
    [string]$GitRepoUrl = "",
    [string]$Model = "ollama/glm-5.1:cloud"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  OpenClaw Employee Setup - Fully Automated" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ──────────────────────────────────────────────────────────
# STEP 1: Check Windows version and admin rights
# ──────────────────────────────────────────────────────────
Write-Host "[1/8] Checking prerequisites..." -ForegroundColor Yellow

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell -> Run as Administrator" -ForegroundColor Red
    exit 1
}

$build = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
Write-Host "  Windows Build: $build (need 19041+)" -ForegroundColor Gray

if ([int]$build -lt 19041) {
    Write-Host "ERROR: Windows Build $build is too old. Need 19041+. Please update Windows first." -ForegroundColor Red
    exit 1
}

Write-Host "  OK Prerequisites check passed" -ForegroundColor Green

# ──────────────────────────────────────────────────────────
# STEP 2: Install WSL2 + Ubuntu
# ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[2/8] Installing WSL2 + Ubuntu..." -ForegroundColor Yellow
Write-Host "  This may take 5-10 minutes on first install." -ForegroundColor Gray

$wslCheck = wsl --list --quiet 2>&1
if ($LASTEXITCODE -ne 0 -or -not $wslCheck) {
    Write-Host "  Installing WSL2 with Ubuntu..." -ForegroundColor Gray
    wsl --install -d Ubuntu --no-launch
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  WSL install command failed. Trying alternate method..." -ForegroundColor Gray
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    }
    Write-Host ""
    Write-Host "  *** RESTART REQUIRED! Please:" -ForegroundColor Red
    Write-Host "  1. Restart this laptop" -ForegroundColor Red
    Write-Host "  2. After restart, open Ubuntu from Start Menu" -ForegroundColor Red
    Write-Host "  3. Create a Linux username and password" -ForegroundColor Red
    Write-Host "  4. Re-run this script (it will skip WSL install on second run)" -ForegroundColor Red
    Write-Host ""
    exit 0
} else {
    Write-Host "  OK WSL2 already installed" -ForegroundColor Green
}

# ──────────────────────────────────────────────────────────
# STEP 3: Set WSL2 as default
# ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[3/8] Setting WSL2 as default..." -ForegroundColor Yellow
wsl --set-default-version 2 2>$null
Write-Host "  OK WSL2 is default" -ForegroundColor Green

# ──────────────────────────────────────────────────────────
# STEP 4: Install Node.js + OpenClaw inside Ubuntu
# ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[4/8] Installing Node.js 22 + OpenClaw inside Ubuntu..." -ForegroundColor Yellow
Write-Host "  This takes 2-3 minutes." -ForegroundColor Gray

$linuxSetup = @"
#!/bin/bash
set -e

echo '=== Updating Ubuntu packages ==='
sudo apt-get update -y
sudo apt-get upgrade -y

echo '=== Installing Node.js 22 ==='
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

echo '=== Verifying Node.js ==='
node --version
npm --version

echo '=== Installing OpenClaw ==='
sudo npm install -g openclaw

echo '=== Verifying OpenClaw ==='
openclaw --version

echo '=== Installing essential tools ==='
sudo apt-get install -y git openssh-server

echo '=== Configuring SSH server ==='
sudo systemctl enable ssh
sudo systemctl start ssh

echo '=== Creating OpenClaw workspace ==='
mkdir -p ~/.openclaw/workspace/memory

echo '=== Initializing git for workspace backup ==='
cd ~/.openclaw/workspace
git init
git config user.name 'EMPLOYEE_NAME_PLACEHOLDER'
git config user.email 'EMPLOYEE_NAME_PLACEHOLDER@company.local'
git add -A 2>/dev/null || true
git commit -m 'Initial workspace' 2>/dev/null || true

echo '=== Node.js + OpenClaw + SSH setup complete ==='
"@

$linuxSetup = $linuxSetup -replace 'EMPLOYEE_NAME_PLACEHOLDER', $EmployeeName

# Write the Linux setup script to a temp file
$linuxSetup | Out-File -FilePath "$env:TEMP\openclaw-linux-setup.sh" -Encoding ascii

# Run it inside WSL
wsl -d Ubuntu -- bash "/mnt/c/Users/$env:USERNAME/AppData/Local/Temp/openclaw-linux-setup.sh"

if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK Node.js + OpenClaw + SSH installed" -ForegroundColor Green
} else {
    Write-Host "  WARNING: Some setup steps may need manual attention. Check errors above." -ForegroundColor Red
}

# ──────────────────────────────────────────────────────────
# STEP 5: Install Windows OpenSSH Server
# ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[5/8] Installing Windows OpenSSH Server..." -ForegroundColor Yellow

$sshCap = Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Server*"
if ($sshCap.State -eq "NotPresent") {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Start-Service sshd
    Set-Service -Name sshd -StartupType Automatic
    Write-Host "  OK Windows SSH server installed and running" -ForegroundColor Green
} else {
    Start-Service sshd 2>$null
    Set-Service -Name sshd -StartupType Automatic 2>$null
    Write-Host "  OK Windows SSH server already available" -ForegroundColor Green
}

# Open firewall for SSH
New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -Profile Any 2>$null | Out-Null

# ──────────────────────────────────────────────────────────
# STEP 6: Configure OpenClaw gateway auto-start
# ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[6/8] Configuring OpenClaw gateway auto-start..." -ForegroundColor Yellow

# Add gateway start to .bashrc if not already there
wsl -d Ubuntu -- bash -c "grep -q 'openclaw gateway' ~/.bashrc 2>/dev/null || echo 'openclaw gateway start --daemon 2>/dev/null' >> ~/.bashrc"

# Enable systemd for auto-start
wsl -d Ubuntu -- bash -c "
if [ -f /etc/wsl.conf ]; then
    sudo grep -q 'systemd=true' /etc/wsl.conf 2>/dev/null || echo -e '[boot]\nsystemd=true' | sudo tee -a /etc/wsl.conf
else
    echo -e '[boot]\nsystemd=true' | sudo tee /etc/wsl.conf
fi
"

Write-Host "  OK Gateway auto-start configured" -ForegroundColor Green

# ──────────────────────────────────────────────────────────
# STEP 7: Get network info for admin access
# ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[7/8] Network info for admin access..." -ForegroundColor Yellow

$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "127.*" } | Select-Object -First 1).IPAddress
$hostname = $env:COMPUTERNAME

Write-Host "  Laptop Name: $hostname" -ForegroundColor White
Write-Host "  IP Address:  $ip" -ForegroundColor White
Write-Host "  SSH Command:  ssh ${EmployeeName}@$ip" -ForegroundColor White
Write-Host "  From WSL:     wsl -d Ubuntu" -ForegroundColor White

# ──────────────────────────────────────────────────────────
# STEP 8: Print summary and next steps
# ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Installed:" -ForegroundColor White
Write-Host "    OK WSL2 + Ubuntu" -ForegroundColor Green
Write-Host "    OK Node.js 22" -ForegroundColor Green
Write-Host "    OK OpenClaw" -ForegroundColor Green
Write-Host "    OK SSH Server (Windows + WSL)" -ForegroundColor Green
Write-Host "    OK Git workspace backup" -ForegroundColor Green
Write-Host "    OK Gateway auto-start" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps (run inside Ubuntu):" -ForegroundColor Cyan
Write-Host "    wsl -d Ubuntu" -ForegroundColor White
Write-Host "    openclaw setup" -ForegroundColor White
Write-Host "    openclaw channels login --channel telegram" -ForegroundColor White
Write-Host "    openclaw gateway start" -ForegroundColor White
Write-Host ""
Write-Host "  Or your admin can SSH in and do it:" -ForegroundColor Cyan
Write-Host "    ssh ${EmployeeName}@$ip" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green

# Save setup info to desktop
$setupInfo = @"
Employee: $EmployeeName
Laptop: $hostname
IP: $ip
Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Status: Setup complete
Next: openclaw setup + telegram config
"@

$setupInfo | Out-File -FilePath "$env:USERPROFILE\Desktop\openclaw-setup-info.txt" -Encoding utf8
Write-Host "  Setup info saved to Desktop\openclaw-setup-info.txt" -ForegroundColor Gray
