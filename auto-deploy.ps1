# Auto-Deploy Script for Dinah Bons Website
# This script monitors file changes and automatically deploys them

param(
    [string]$RemoteServer = "your-server.com",
    [string]$RemotePath = "/var/www/html/",
    [string]$Username = "your-username",
    [string]$LocalPath = ".",
    [int]$CheckInterval = 5
)

# Colors for output
Write-Host "🚀 Auto-Deploy Script Started for Dinah Bons Website" -ForegroundColor Cyan
Write-Host "📁 Monitoring: $LocalPath" -ForegroundColor Yellow
Write-Host "🌐 Remote: $RemoteServer$RemotePath" -ForegroundColor Yellow
Write-Host "⏱️  Check interval: $CheckInterval seconds" -ForegroundColor Yellow
Write-Host ""

# Function to get file hash for change detection
function Get-FileHash {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        return (Get-FileHash -Algorithm MD5 -Path $FilePath).Hash
    }
    return $null
}

# Function to deploy files
function Deploy-Files {
    param([string[]]$ChangedFiles)
    
    Write-Host "🔄 Deploying changes..." -ForegroundColor Yellow
    
    foreach ($file in $ChangedFiles) {
        $relativePath = $file.Replace($LocalPath, "").TrimStart("\")
        $remoteFile = "$RemotePath$relativePath"
        
        Write-Host "  📤 Uploading: $relativePath" -ForegroundColor White
        
        # Option 1: Using SCP (if you have SSH access)
        try {
            scp -i "~/.ssh/id_rsa" "$file" "$Username@$RemoteServer`:$remoteFile"
            Write-Host "    ✅ Uploaded via SCP" -ForegroundColor Green
        }
        catch {
            Write-Host "    ❌ SCP failed, trying alternative method..." -ForegroundColor Red
            
            # Option 2: Using FTP (if you have FTP access)
            try {
                $ftp = "ftp://$RemoteServer$remoteFile"
                $webClient = New-Object System.Net.WebClient
                $webClient.Credentials = New-Object System.Net.NetworkCredential($Username, "your-password")
                $webClient.UploadFile($ftp, $file)
                Write-Host "    ✅ Uploaded via FTP" -ForegroundColor Green
            }
            catch {
                Write-Host "    ❌ FTP also failed" -ForegroundColor Red
            }
        }
    }
    
    Write-Host "🎉 Deployment completed!" -ForegroundColor Green
    Write-Host "🌐 Check your website: https://dinahbons.nl" -ForegroundColor Cyan
    Write-Host ""
}

# Function to check for changes
function Check-ForChanges {
    $currentHashes = @{}
    $changedFiles = @()
    
    # Get all HTML, CSS, JS files
    $files = Get-ChildItem -Path $LocalPath -Recurse -Include "*.html", "*.css", "*.js", "*.jpeg", "*.jpg", "*.png" | Where-Object { $_.FullName -notlike "*\.git\*" }
    
    foreach ($file in $files) {
        $hash = Get-FileHash -FilePath $file.FullName
        $currentHashes[$file.FullName] = $hash
    }
    
    return $currentHashes
}

# Main monitoring loop
Write-Host "🔍 Starting file monitoring..." -ForegroundColor Green
$previousHashes = Check-ForChanges

while ($true) {
    Start-Sleep -Seconds $CheckInterval
    
    $currentHashes = Check-ForChanges
    $changedFiles = @()
    
    # Compare hashes
    foreach ($file in $currentHashes.Keys) {
        if ($previousHashes[$file] -ne $currentHashes[$file]) {
            $changedFiles += $file
            Write-Host "📝 Change detected: $($file.Split('\')[-1])" -ForegroundColor Yellow
        }
    }
    
    # Deploy if changes found
    if ($changedFiles.Count -gt 0) {
        Write-Host "🚀 Changes detected! Deploying..." -ForegroundColor Green
        Deploy-Files -ChangedFiles $changedFiles
        $previousHashes = $currentHashes.Clone()
    }
    
    # Show status
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] Monitoring... (Press Ctrl+C to stop)" -ForegroundColor Gray
}

# Cleanup on exit
Write-Host "🛑 Auto-deploy script stopped" -ForegroundColor Red
