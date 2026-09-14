<#
.SYNOPSIS
Builds the MSIX package for publishing PPPLAYER to the Microsoft Store.

.DESCRIPTION
This script cleans the Flutter project, installs dependencies, and runs the msix:create command with the --store flag to generate an MSIX file ready for the Microsoft Store.

.EXAMPLE
.\scripts\build_windows_msix.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $ProjectRoot

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Building PPPLAYER Windows MSIX Package " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Cleaning project..." -ForegroundColor Yellow
flutter clean

Write-Host "`n[2/3] Fetching dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "`n[3/3] Building and packaging MSIX..." -ForegroundColor Yellow
# The --store flag indicates the package will be uploaded to the Microsoft Store.
# The store handles the code signing.
dart run msix:create --store

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "SUCCESS! The MSIX package is ready." -ForegroundColor Green
Write-Host "Path: build\windows\x64\runner\Release\ppplayer.msix" -ForegroundColor Cyan
Write-Host "Upload this file directly to the Microsoft Partner Center." -ForegroundColor White
Write-Host "==========================================" -ForegroundColor Cyan
