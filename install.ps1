# =============================================================================
#                               INSTALL.PS1
# =============================================================================
# Idempotent PowerShell setup script for native Windows environments.
# Requires PowerShell 7+. Installs Scoop, Neovim, Git, Starship,
# JetBrains Mono Nerd Font, WezTerm, and registers config directories.
# =============================================================================

# --- 1. Version Guard ---
# Ensure PowerShell 7+ (pwsh) is running (mu-vim does not support Windows PowerShell 5.1).
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "[!] ERROR: mu-vim installation requires PowerShell 7+." -ForegroundColor Red
    Write-Host "Please download and install the latest PowerShell version from:" -ForegroundColor Yellow
    Write-Host "https://github.com/PowerShell/PowerShell/releases" -ForegroundColor Blue
    Exit
}

# --- 2. Indicators and Output Helpers ---
function Log-Step ($message) {
    Write-Host "[→] $message..." -ForegroundColor Cyan
}

function Log-Success ($message) {
    Write-Host "[✓] $message" -ForegroundColor Green
}

function Log-Warn ($message) {
    Write-Host "[!] $message" -ForegroundColor Yellow
}

function Log-Error ($message) {
    Write-Host "[!] ERROR: $message" -ForegroundColor Red
}

Log-Step "Starting native Windows installer (PowerShell 7+)"

# --- 3. Define Backup Location ---
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = Join-Path $env:USERPROFILE "mu-vim-backup\$timestamp"

function Create-Backup ($targetPath, $name) {
    if (Test-Path $targetPath) {
        if (!(Test-Path $backupDir)) {
            $null = New-Item -Path $backupDir -ItemType Directory -Force
        }
        Log-Warn "Existing $name configuration found at $targetPath. Backing up to mu-vim-backup\"
        Move-Item -Path $targetPath -Destination $backupDir -Force
    }
}

# --- 4. Install Package Managers & Dependencies ---

# Check/Install Scoop (runs in user-space, no admin/UAC popup required!)
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Log-Step "Scoop not found. Installing Scoop"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    if (!(Test-Path "$env:USERPROFILE\scoop")) {
        Log-Error "Scoop installation failed. Aborting."
        Exit
    }
    Log-Success "Scoop installed successfully"
} else {
    Log-Success "Scoop already installed"
}

# Add standard Scoop buckets
Log-Step "Adding Scoop buckets (extras, nerd-fonts)"
scoop bucket add extras 2>$null
scoop bucket add nerd-fonts 2>$null

# Install Git, Neovim, Starship, and Nerd Font via Scoop
$packages = @("git", "neovim", "starship", "JetBrainsMono-NF")
foreach ($pkg in $packages) {
    if (!(scoop which $pkg 2>$null) -and ($pkg -ne "JetBrainsMono-NF" -or !(Test-Path "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\JetBrainsMono*Nerd*"))) {
        Log-Step "Installing $pkg via Scoop"
        scoop install $pkg
        Log-Success "$pkg installed successfully"
    } else {
        Log-Success "$pkg already installed"
    }
}

# Install WezTerm via winget (Windows Package Manager)
if (!(Get-Command wezterm -ErrorAction SilentlyContinue)) {
    Log-Step "Installing WezTerm via winget"
    winget install --id wez.wezterm --silent --accept-source-agreements --accept-package-agreements
    Log-Success "WezTerm installed successfully"
} else {
    Log-Success "WezTerm already installed"
}

# --- 5. Place Configuration Files ---

Log-Step "Copying configurations to XDG/Windows directories"

# 1. Copy Neovim configs to %LOCALAPPDATA%\nvim\
$nvimConfigDir = Join-Path $env:LOCALAPPDATA "nvim"
Create-Backup $nvimConfigDir "Neovim"
$null = New-Item -Path $nvimConfigDir -ItemType Directory -Force
Copy-Item -Path "nvim\*" -Destination $nvimConfigDir -Recurse -Force
if (Test-Path "lazy-lock.json") {
    Copy-Item -Path "lazy-lock.json" -Destination (Join-Path $nvimConfigDir "lazy-lock.json") -Force
}
Log-Success "Neovim configurations placed at $nvimConfigDir"

# 2. Copy WezTerm configs to %USERPROFILE%\.config\wezterm\wezterm.lua
$weztermConfigDir = Join-Path $env:USERPROFILE ".config\wezterm"
Create-Backup $weztermConfigDir "WezTerm"
$null = New-Item -Path $weztermConfigDir -ItemType Directory -Force
Copy-Item -Path "wezterm\.wezterm.lua" -Destination (Join-Path $weztermConfigDir "wezterm.lua") -Force

# Windows fallback: copy to ~/.wezterm.lua
$weztermFallback = Join-Path $env:USERPROFILE ".wezterm.lua"
Create-Backup $weztermFallback "WezTerm (Legacy/Fallback)"
Copy-Item -Path "wezterm\.wezterm.lua" -Destination $weztermFallback -Force
Log-Success "WezTerm configurations placed at $weztermConfigDir"

# 3. Configure PowerShell Profile
# Find PowerShell profile path ($PROFILE)
$profileDir = Split-Path $PROFILE -Parent
if (!(Test-Path $profileDir)) {
    $null = New-Item -Path $profileDir -ItemType Directory -Force
}
Create-Backup $PROFILE "PowerShell Profile"
Copy-Item -Path "powershell\profile.ps1" -Destination $PROFILE -Force
Log-Success "PowerShell Profile placed at $PROFILE"

# --- 6. End Checklist ---
Write-Host ""
Write-Host "=========================================================================" -ForegroundColor Green
Write-Host "                   μ-VIM INSTALLATION COMPLETED!" -ForegroundColor Green
Write-Host "=========================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "To complete setting up, review this manual checklist:"
Write-Host ""
Write-Host " [→] Start Neovim to let lazy.nvim load and compile plugins:" -ForegroundColor Cyan
Write-Host "     nvim" -ForegroundColor Yellow
Write-Host " [→] Open Mason (LSP Manager) inside Neovim and run installations:" -ForegroundColor Cyan
Write-Host "     Launch nvim, then type: :Mason" -ForegroundColor Yellow
Write-Host " [→] Setup GitHub Copilot:" -ForegroundColor Cyan
Write-Host "     Launch nvim, run: :Copilot auth" -ForegroundColor Yellow
Write-Host "     Enable copilot suggestions temporarily with: <leader>cp" -ForegroundColor Yellow
Write-Host " [→] Windows Native DAP compiler requirement:" -ForegroundColor Cyan
Write-Host "     Native debugging (C/C++ codelldb) requires standard MSVC or MinGW" -ForegroundColor Yellow
Write-Host "     compilers to be pre-installed and available in your shell system PATH." -ForegroundColor Yellow
Write-Host ""
Write-Host "Enjoy your new developer environment!" -ForegroundColor Green
Write-Host ""
