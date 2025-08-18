# Watch and Deploy Script
# Automatically detects file changes and deploys them

Write-Host "🔍 File Watcher Started for Dinah Bons Website" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop monitoring" -ForegroundColor Yellow
Write-Host ""

# Configuration - Edit these values
$ftpServer = "your-ftp-server.com"
$ftpUsername = "your-username" 
$ftpPassword = "your-password"
$remotePath = "/public_html/"

# Function to upload file via FTP
function Upload-File {
    param([string]$FilePath)
    
    $relativePath = $FilePath.Replace((Get-Location).Path, "").TrimStart("\")
    $ftpUri = "ftp://$ftpServer$remotePath$relativePath"
    
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
        $webClient.UploadFile($ftpUri, $FilePath)
        Write-Host "✅ Uploaded: $relativePath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Failed to upload: $relativePath" -ForegroundColor Red
        return $false
    }
}

# Function to deploy all files
function Deploy-All {
    Write-Host "🚀 Deploying all files..." -ForegroundColor Yellow
    
    $files = Get-ChildItem -Recurse -Include "*.html", "*.css", "*.js", "*.jpeg", "*.jpg", "*.png" | Where-Object { $_.FullName -notlike "*\.git\*" }
    
    $successCount = 0
    foreach ($file in $files) {
        if (Upload-File -FilePath $file.FullName) {
            $successCount++
        }
    }
    
    Write-Host "🎉 Deployment completed! $successCount/$($files.Count) files uploaded" -ForegroundColor Green
    Write-Host "🌐 Check your website: https://dinahbons.nl" -ForegroundColor Cyan
}

# Function to watch for changes
function Watch-Files {
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = (Get-Location).Path
    $watcher.Filter = "*.*"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    
    # Register event handlers
    $action = {
        $path = $Event.SourceEventArgs.FullPath
        $changeType = $Event.SourceEventArgs.ChangeType
        $fileName = Split-Path $path -Leaf
        
        if ($fileName -match "\.(html|css|js|jpeg|jpg|png)$" -and $path -notlike "*\.git\*") {
            Write-Host "📝 $changeType detected: $fileName" -ForegroundColor Yellow
            
            # Wait a bit for file to finish writing
            Start-Sleep -Seconds 2
            
            # Upload the changed file
            & Upload-File -FilePath $path
        }
    }
    
    Register-ObjectEvent $watcher "Changed" -Action $action | Out-Null
    Register-ObjectEvent $watcher "Created" -Action $action | Out-Null
    Register-ObjectEvent $watcher "Deleted" -Action $action | Out-Null
    
    Write-Host "👀 Watching for file changes..." -ForegroundColor Green
    Write-Host "Files will be automatically uploaded when changed" -ForegroundColor White
    Write-Host ""
    
    # Keep script running
    try {
        while ($true) {
            Start-Sleep -Seconds 1
        }
    }
    finally {
        $watcher.EnableRaisingEvents = $false
        $watcher.Dispose()
        Write-Host "🛑 File watching stopped" -ForegroundColor Red
    }
}

# Main menu
Write-Host "Choose an option:" -ForegroundColor Cyan
Write-Host "1. Deploy all files now" -ForegroundColor White
Write-Host "2. Start watching for changes (auto-deploy)" -ForegroundColor White
Write-Host "3. Exit" -ForegroundColor White
Write-Host ""
Write-Host "Enter choice (1-3): " -NoNewline -ForegroundColor Yellow
$choice = Read-Host

switch ($choice) {
    "1" { Deploy-All }
    "2" { Watch-Files }
    "3" { Write-Host "👋 Goodbye!" -ForegroundColor Green; exit }
    default { Write-Host "❌ Invalid choice" -ForegroundColor Red }
}
