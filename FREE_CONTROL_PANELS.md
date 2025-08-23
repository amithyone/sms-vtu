# Free Control Panels for Your SMS-VTU Server

## 🎉 Cockpit is Now Installed!

**Cockpit** is now successfully installed on your server! This is a modern, web-based control panel that comes with Ubuntu.

### Access Cockpit
- **URL**: https://75.119.155.252:9090
- **Username**: root
- **Password**: Enter0text@@@#

### Cockpit Features
✅ **System Overview** - CPU, memory, disk usage  
✅ **File Management** - Browse and edit files  
✅ **Service Management** - Start/stop services  
✅ **Network Configuration** - Manage network settings  
✅ **Storage Management** - Disk and partition management  
✅ **Package Management** - Install/update software  
✅ **User Management** - Create/edit system users  
✅ **Terminal Access** - Web-based terminal  

## Alternative Free Control Panels

### 1. **Webmin** (Most Popular)
```bash
# Install Webmin manually
cd /tmp
wget https://prdownloads.sourceforge.net/webadmin/webmin_2.001_all.deb
dpkg -i webmin_2.001_all.deb
apt-get install -f
```
- **URL**: https://75.119.155.252:10000
- **Features**: Full-featured like cPanel, file manager, database management

### 2. **Froxlor** (Lightweight)
```bash
# Install Apache and PHP first
apt install -y apache2 php8.1 php8.1-mysql php8.1-curl php8.1-gd php8.1-mbstring php8.1-xml php8.1-zip

# Download and install Froxlor
cd /var/www
wget https://files.froxlor.org/releases/froxlor-latest.tar.gz
tar -xzf froxlor-latest.tar.gz
chown -R www-data:www-data froxlor
```
- **URL**: http://75.119.155.252/froxlor
- **Features**: Lightweight, good for hosting management

### 3. **ISPConfig** (Advanced)
```bash
# Install ISPConfig
cd /tmp
wget -O ispconfig.tar.gz "https://ispconfig.org/downloads/ISPConfig-3.2.5.tar.gz"
tar xfz ispconfig.tar.gz
cd ispconfig3_install/install/
php -q install.php
```
- **URL**: http://75.119.155.252:8080
- **Features**: Professional hosting panel, multiple domains

### 4. **Ajenti** (Modern UI)
```bash
# Install Ajenti
curl https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install.sh | bash -s -
```
- **URL**: https://75.119.155.252:8000
- **Features**: Modern interface, plugin system

## Recommended Setup for Your SMS-VTU Project

### Current Setup (Recommended)
1. **Cockpit** - For system management
2. **Manual file editing** - For code changes
3. **Git** - For version control

### Enhanced Setup
1. **Cockpit** - System management
2. **Webmin** - File and database management
3. **Git** - Version control

## Quick Commands for Your Project

### File Management with Cockpit
1. Go to https://75.119.155.252:9090
2. Login with root credentials
3. Click on "Files" in the left sidebar
4. Navigate to `/var/www/sms-vtu/`
5. Edit files directly in the browser

### Database Management
```bash
# Access MySQL via command line
mysql -u root -p

# Or use Cockpit's terminal feature
# Go to Cockpit → Terminal
mysql -u root -p
```

### Service Management
```bash
# Restart Nginx
systemctl restart nginx

# Restart PHP-FPM
systemctl restart php8.1-fpm

# Check service status
systemctl status nginx
systemctl status php8.1-fpm
```

## Security Considerations

### Firewall Setup
```bash
# Allow Cockpit port
ufw allow 9090

# Allow your application ports
ufw allow 80
ufw allow 443

# Enable firewall
ufw enable
```

### SSL/HTTPS Setup
```bash
# Install Certbot for Let's Encrypt
apt install -y certbot python3-certbot-nginx

# Get SSL certificate
certbot --nginx -d yourdomain.com
```

## Next Steps

1. **Access Cockpit**: https://75.119.155.252:9090
2. **Explore the interface** - Check system stats, services, files
3. **Set up SSL** for secure access
4. **Configure backups** using Cockpit's storage features
5. **Monitor your application** using system statistics

## Troubleshooting

### Cockpit Not Accessible
```bash
# Check if Cockpit is running
systemctl status cockpit

# Restart Cockpit
systemctl restart cockpit

# Check firewall
ufw status
```

### File Permissions
```bash
# Fix file permissions for your project
chown -R www-data:www-data /var/www/sms-vtu
chmod -R 755 /var/www/sms-vtu
```

### Database Access
```bash
# Reset MySQL root password if needed
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
```

## Summary

You now have **Cockpit** installed and ready to use! This gives you a modern, web-based interface to manage your server without using command line. You can:

- ✅ Manage files through web interface
- ✅ Monitor system resources
- ✅ Manage services (Nginx, MySQL, PHP)
- ✅ Access terminal through browser
- ✅ Manage users and permissions
- ✅ Monitor logs and system status

**Access your control panel at**: https://75.119.155.252:9090
