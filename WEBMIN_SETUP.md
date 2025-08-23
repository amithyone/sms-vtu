# Webmin Setup Guide for SMS-VTU Server

## What is Webmin?
Webmin is a free, web-based control panel for Linux servers. It provides a user-friendly interface for:
- File management
- Database management
- User management
- System monitoring
- Service management
- And much more!

## Installation Steps

### 1. Connect to your server
```bash
ssh root@75.119.155.252
```

### 2. Update system and install dependencies
```bash
apt update
apt install -y software-properties-common apt-transport-https wget
```

### 3. Add Webmin repository
```bash
wget -q -O- http://www.webmin.com/jcameron-key.asc | apt-key add -
echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list
```

### 4. Install Webmin
```bash
apt update
apt install -y webmin
```

### 5. Access Webmin
- **URL**: https://75.119.155.252:10000
- **Username**: root
- **Password**: Your server root password (Enter0text@@@#)

### 6. Configure firewall (if needed)
```bash
ufw allow 10000
```

## Webmin Features for Your SMS-VTU Project

### File Manager
- Navigate to: **File Manager** in the left sidebar
- Manage all files in `/var/www/sms-vtu/`
- Upload, edit, delete files through web interface
- Set file permissions

### Database Management
- Navigate to: **Servers** → **MySQL Database Server**
- Manage your `newsms_db` database
- Create/edit tables
- Import/export data
- Run SQL queries

### System Monitoring
- Navigate to: **System** → **System Statistics**
- Monitor CPU, memory, disk usage
- View running processes
- Check system logs

### Service Management
- Navigate to: **System** → **Bootup and Shutdown**
- Start/stop/restart services
- Manage Nginx, MySQL, PHP-FPM

### User Management
- Navigate to: **System** → **Users and Groups**
- Create/edit system users
- Manage file permissions

## Alternative Free Control Panels

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

### 3. **ISPConfig** (Advanced)
```bash
# Install ISPConfig
cd /tmp
wget -O ispconfig.tar.gz "https://ispconfig.org/downloads/ISPConfig-3.2.5.tar.gz"
tar xfz ispconfig.tar.gz
cd ispconfig3_install/install/
php -q install.php
```

### 4. **Ajenti** (Modern UI)
```bash
# Install Ajenti
curl https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install.sh | bash -s -
```

## Recommended: Webmin Setup

Let's install Webmin on your server now:
<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>
run_terminal_cmd
