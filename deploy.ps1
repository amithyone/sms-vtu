# SMS-VTU Deployment Script for Contabo Ubuntu Server
# Run this script to deploy your application

Write-Host "Starting deployment to Contabo server..." -ForegroundColor Green

# Server details
$SERVER_IP = "75.119.155.252"
$SERVER_USER = "root"
$SERVER_PASSWORD = "Enter0text@@@#"

# Function to run SSH command with password
function Invoke-SSHCommand {
    param(
        [string]$Command
    )
    
    $sshCommand = "ssh $SERVER_USER@$SERVER_IP `"$Command`""
    Write-Host "Running: $sshCommand" -ForegroundColor Yellow
    Invoke-Expression $sshCommand
}

# 1. Update system and install dependencies
Write-Host "Step 1: Installing dependencies..." -ForegroundColor Cyan
Invoke-SSHCommand "apt update && apt install -y nginx mysql-server php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd php8.1-cli composer nodejs git"

# 2. Create database
Write-Host "Step 2: Setting up database..." -ForegroundColor Cyan
Invoke-SSHCommand "mysql -u root -e 'CREATE DATABASE IF NOT EXISTS newsms_db;'"

# 3. Clone repository
Write-Host "Step 3: Cloning repository..." -ForegroundColor Cyan
Invoke-SSHCommand "cd /var/www && rm -rf sms-vtu && git clone https://github.com/amithyone/sms-vtu.git"

# 4. Setup Laravel backend
Write-Host "Step 4: Setting up Laravel backend..." -ForegroundColor Cyan
Invoke-SSHCommand "cd /var/www/sms-vtu/laravel-backend && composer install --no-dev --optimize-autoloader"

# 5. Create Laravel environment file
Write-Host "Step 5: Creating Laravel environment..." -ForegroundColor Cyan
Invoke-SSHCommand "cd /var/www/sms-vtu/laravel-backend && echo 'APP_NAME=SMS-VTU' > .env && echo 'APP_ENV=production' >> .env && echo 'APP_DEBUG=false' >> .env && echo 'APP_URL=http://$SERVER_IP' >> .env && echo 'DB_CONNECTION=mysql' >> .env && echo 'DB_HOST=127.0.0.1' >> .env && echo 'DB_PORT=3306' >> .env && echo 'DB_DATABASE=newsms_db' >> .env && echo 'DB_USERNAME=root' >> .env && echo 'DB_PASSWORD=' >> .env"

# 6. Setup React frontend
Write-Host "Step 6: Setting up React frontend..." -ForegroundColor Cyan
Invoke-SSHCommand "cd /var/www/sms-vtu/newsms && npm install && npm run build"

# 7. Configure Nginx
Write-Host "Step 7: Configuring Nginx..." -ForegroundColor Cyan
$nginxConfig = @"
server {
    listen 80;
    server_name $SERVER_IP;
    root /var/www/sms-vtu/newsms/dist;
    index index.html;

    # Frontend - React app
    location / {
        try_files `$uri `$uri/ /index.html;
    }

    # Backend API
    location /api/ {
        proxy_pass http://127.0.0.1:8000/;
        proxy_set_header Host `$host;
        proxy_set_header X-Real-IP `$remote_addr;
        proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto `$scheme;
    }

    # Static files
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
"@

# Save nginx config
$nginxConfig | Out-File -FilePath "nginx-config.conf" -Encoding UTF8
Invoke-SSHCommand "cat > /etc/nginx/sites-available/sms-vtu << 'EOF'
$nginxConfig
EOF"

# 8. Enable site and restart services
Write-Host "Step 8: Enabling site and restarting services..." -ForegroundColor Cyan
Invoke-SSHCommand "ln -sf /etc/nginx/sites-available/sms-vtu /etc/nginx/sites-enabled/ && rm -f /etc/nginx/sites-enabled/default && nginx -t && systemctl restart nginx"

# 9. Set permissions
Write-Host "Step 9: Setting permissions..." -ForegroundColor Cyan
Invoke-SSHCommand "chown -R www-data:www-data /var/www/sms-vtu && chmod -R 755 /var/www/sms-vtu"

Write-Host "Deployment completed!" -ForegroundColor Green
Write-Host "Your application should be available at: http://$SERVER_IP" -ForegroundColor Green
Write-Host "Frontend: http://$SERVER_IP" -ForegroundColor Yellow
Write-Host "Backend API: http://$SERVER_IP/api" -ForegroundColor Yellow

