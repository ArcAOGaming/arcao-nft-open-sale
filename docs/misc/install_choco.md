# Chocolatey Installation Guide

Chocolatey is a package manager for Windows that makes it easy to install and manage software packages. This guide will walk you through installing Chocolatey on your Windows system.

## Prerequisites

- Windows 7+ / Windows Server 2003+
- PowerShell v2+
- .NET Framework 4+ (the installation will attempt to install .NET 4.0 if you don't have it installed)
- Administrator privileges

## Installation Steps

1. Open PowerShell as Administrator
   - Right-click on PowerShell
   - Select "Run as Administrator"

2. Run the following command to ensure PowerShell's execution policy is not restricted:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```

3. Run the installation command:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

4. Verify the installation by running:
   ```powershell
   choco --version
   ```

## Usage

After installation, you can install packages using:
```powershell
choco install <package-name>
```

For example, to install Node.js:
```powershell
choco install nodejs
```

## Common Commands

- Install a package: `choco install <package>`
- Upgrade a package: `choco upgrade <package>`
- List installed packages: `choco list --local-only`
- Search for packages: `choco search <package>`
- Uninstall a package: `choco uninstall <package>`