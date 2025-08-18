# Simple Deploy Script for Dinah Bons Website
# Choose your deployment method and run this script

Write-Host "🚀 Dinah Bons Website - Deployment Options" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""

# Option 1: Git Push (if using GitHub Pages or similar)
Write-Host "1️⃣  Git Push (GitHub Pages, Netlify, Vercel)" -ForegroundColor Green
Write-Host "   Run: git add . && git commit -m 'Update website' && git push" -ForegroundColor White
Write-Host ""

# Option 2: FTP Upload
Write-Host "2️⃣  FTP Upload" -ForegroundColor Green
Write-Host "   Edit this script with your FTP details and run it" -ForegroundColor White
Write-Host ""

# Option 3: SCP Upload (SSH)
Write-Host "3️⃣  SCP Upload (SSH)" -ForegroundColor Green
Write-Host "   Edit this script with your server details and run it" -ForegroundColor White
Write-Host ""

# Option 4: Manual Upload
Write-Host "4️⃣  Manual Upload" -ForegroundColor Green
Write-Host "   Use your hosting provider's file manager or cPanel" -ForegroundColor White
Write-Host ""

Write-Host "Choose your option (1-4): " -NoNewline -ForegroundColor Cyan
$choice = Read-Host

switch ($choice) {
    "1" { 
        Write-Host "🚀 Deploying via Git..." -ForegroundColor Green
        git add .
        git commit -m "Update website - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git push
        Write-Host "✅ Git push completed!" -ForegroundColor Green
    }
    "2" { 
        Write-Host "🚀 Deploying via FTP..." -ForegroundColor Green
        # Edit these values with your FTP details
        $ftpServer = "your-ftp-server.com"
        $ftpUsername = "your-username"
        $ftpPassword = "your-password"
        $remotePath = "/public_html/"
        
        $files = Get-ChildItem -Recurse -Include "*.html", "*.css", "*.js", "*.jpeg", "*.jpg", "*.png"
        
        foreach ($file in $files) {
            $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart("\")
            $ftpUri = "ftp://$ftpServer$remotePath$relativePath"
            
            try {
                $webClient = New-Object System.Net.WebClient
                $webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
                $webClient.UploadFile($ftpUri, $file.FullName)
                Write-Host "✅ Uploaded: $relativePath" -ForegroundColor Green
            }
            catch {
                Write-Host "❌ Failed to upload: $relativePath" -ForegroundColor Red
            }
        }
    }
    "3" { 
        Write-Host "🚀 Deploying via SCP..." -ForegroundColor Green
        # Edit these values with your server details
        $server = "your-server.com"
        $username = "your-username"
        $remotePath = "/var/www/html/"
        
        $files = Get-ChildItem -Recurse -Include "*.html", "*.css", "*.js", "*.jpeg", "*.jpg", "*.png"
        
        foreach ($file in $files) {
            $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart("\")
            $remoteFile = "$remotePath$relativePath"
            
            try {
                scp "$($file.FullName)" "$username@$server`:$remoteFile"
                Write-Host "✅ Uploaded: $relativePath" -ForegroundColor Green
            }
            catch {
                Write-Host "❌ Failed to upload: $relativePath" -ForegroundColor Red
            }
        }
    }
    "4" { 
        Write-Host "📁 Manual Upload Instructions:" -ForegroundColor Yellow
        Write-Host "1. Go to your hosting provider's control panel" -ForegroundColor White
        Write-Host "2. Open File Manager or cPanel File Manager" -ForegroundColor White
        Write-Host "3. Navigate to public_html or www folder" -ForegroundColor White
        Write-Host "4. Upload all your HTML, CSS, JS, and image files" -ForegroundColor White
        Write-Host "5. Make sure images are in an 'images' folder" -ForegroundColor White
    }
    default { 
        Write-Host "❌ Invalid choice. Please run the script again." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🌐 Check your website: https://dinahbons.nl" -ForegroundColor Cyan
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
