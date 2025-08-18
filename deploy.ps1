# Main Deployment Script for Dinah Bons Website
# Reads configuration from deploy-config.json

# Check if config file exists
if (-not (Test-Path "deploy-config.json")) {
    Write-Host "❌ Configuration file 'deploy-config.json' not found!" -ForegroundColor Red
    Write-Host "Please create it with your deployment settings" -ForegroundColor Yellow
    exit 1
}

# Load configuration
try {
    $config = Get-Content "deploy-config.json" | ConvertFrom-Json
    Write-Host "✅ Configuration loaded successfully" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error loading configuration file" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Dinah Bons Website Deployment" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Yellow
Write-Host "Method: $($config.deployment.method)" -ForegroundColor White
Write-Host "Website: $($config.website.name)" -ForegroundColor White
Write-Host "URL: $($config.website.url)" -ForegroundColor White
Write-Host ""

# Function to deploy via FTP
function Deploy-FTP {
    $ftp = $config.deployment.ftp
    Write-Host "📤 Deploying via FTP to $($ftp.server)..." -ForegroundColor Yellow
    
    $files = Get-ChildItem -Recurse -Include $config.files.include | Where-Object { 
        $exclude = $false
        foreach ($pattern in $config.files.exclude) {
            if ($_.FullName -like "*$pattern*") { $exclude = $true; break }
        }
        -not $exclude
    }
    
    $successCount = 0
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart("\")
        $ftpUri = "ftp://$($ftp.server)$($ftp.remotePath)$relativePath"
        
        try {
            $webClient = New-Object System.Net.WebClient
            $webClient.Credentials = New-Object System.Net.NetworkCredential($ftp.username, $ftp.password)
            $webClient.UploadFile($ftpUri, $file.FullName)
            Write-Host "  ✅ $relativePath" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "  ❌ $relativePath" -ForegroundColor Red
        }
    }
    
    Write-Host "🎉 FTP deployment completed! $successCount/$($files.Count) files uploaded" -ForegroundColor Green
}

# Function to deploy via SCP
function Deploy-SCP {
    $scp = $config.deployment.scp
    Write-Host "📤 Deploying via SCP to $($scp.server)..." -ForegroundColor Yellow
    
    $files = Get-ChildItem -Recurse -Include $config.files.include | Where-Object { 
        $exclude = $false
        foreach ($pattern in $config.files.exclude) {
            if ($_.FullName -like "*$pattern*") { $exclude = $true; break }
        }
        -not $exclude
    }
    
    $successCount = 0
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart("\")
        $remoteFile = "$($scp.remotePath)$relativePath"
        
        try {
            scp "$($file.FullName)" "$($scp.username)@$($scp.server)`:$remoteFile"
            Write-Host "  ✅ $relativePath" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "  ❌ $relativePath" -ForegroundColor Red
        }
    }
    
    Write-Host "🎉 SCP deployment completed! $successCount/$($files.Count) files uploaded" -ForegroundColor Green
}

# Function to deploy via Git
function Deploy-Git {
    $git = $config.deployment.git
    Write-Host "📤 Deploying via Git..." -ForegroundColor Yellow
    
    try {
        git add .
        git commit -m "Update website - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git push $git.remote $git.branch
        Write-Host "✅ Git deployment completed!" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Git deployment failed!" -ForegroundColor Red
    }
}

# Main deployment logic
switch ($config.deployment.method.ToLower()) {
    "ftp" { Deploy-FTP }
    "scp" { Deploy-SCP }
    "git" { Deploy-Git }
    default { 
        Write-Host "❌ Unknown deployment method: $($config.deployment.method)" -ForegroundColor Red
        Write-Host "Supported methods: ftp, scp, git" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🌐 Check your website: $($config.website.url)" -ForegroundColor Cyan
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
