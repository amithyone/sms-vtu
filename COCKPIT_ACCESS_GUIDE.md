# Cockpit Access Guide for SMS-VTU Server

## 🎯 **Cockpit is Running Successfully!**

Your Cockpit control panel is installed and running on your server. Here's how to access it:

## 📍 **Access URLs**

### ✅ **HTTP Access (Working Now)**
- **URL**: http://75.119.155.252:9090
- **Username**: root
- **Password**: Enter0text@@@#

### 🔒 **HTTPS Access (With SSL Certificate)**
- **URL**: https://75.119.155.252:9090
- **Username**: root
- **Password**: Enter0text@@@#

## 🔧 **Fixed: HTTPS Redirect Issue**

The HTTPS redirect issue has been resolved! Cockpit is now configured to:
- ✅ Allow HTTP access without redirecting to HTTPS
- ✅ Accept both HTTP and HTTPS connections
- ✅ Work with self-signed certificates

## 🎨 **What You'll See in Cockpit**

Once you successfully access Cockpit, you'll see:

### Dashboard
- **System Overview**: CPU, memory, disk usage
- **System Information**: OS version, uptime, hostname
- **Quick Actions**: Restart, shutdown, terminal

### Left Sidebar
- **Overview**: System dashboard
- **Logs**: System and service logs
- **Storage**: Disk and partition management
- **Networking**: Network configuration
- **Accounts**: User management
- **Services**: Service management
- **Terminal**: Web-based terminal
- **Files**: File browser

## 📁 **Managing Your SMS-VTU Project**

### File Management
1. Click on **"Files"** in the left sidebar
2. Navigate to `/var/www/sms-vtu/`
3. Browse your project files
4. Edit files directly in the browser

### Service Management
1. Click on **"Services"** in the left sidebar
2. Find and manage:
   - **nginx** - Web server
   - **mysql** - Database server
   - **php8.1-fpm** - PHP processor

### Terminal Access
1. Click on **"Terminal"** in the left sidebar
2. Run commands directly in the browser
3. Example commands:
   ```bash
   cd /var/www/sms-vtu
   ls -la
   systemctl status nginx
   ```

## 🛠️ **Server Status Check**

If you still can't access Cockpit, here's how to check if it's running:

```bash
# Connect to your server
ssh root@75.119.155.252

# Check if Cockpit is running
systemctl status cockpit

# Check if port 9090 is listening
netstat -tlnp | grep 9090

# Restart Cockpit if needed
systemctl restart cockpit
```

## 🔒 **Security Note**

- Cockpit is configured to allow both HTTP and HTTPS access
- HTTP access is enabled for easier setup
- HTTPS uses self-signed certificate (browser will show warning)
- Always use strong passwords

## 🆘 **Still Having Issues?**

If you still can't access Cockpit:

1. **Try HTTP first**: http://75.119.155.252:9090
2. **Clear browser cache** and try again
3. **Try different browser** (Chrome, Firefox, Edge, Safari)
4. **Try incognito/private mode**
5. **Check your internet connection**
6. **Use the command line** as an alternative:
   ```bash
   ssh root@75.119.155.252
   ```

## 🎉 **Success!**

Once you access Cockpit, you'll have a powerful web-based interface to manage your entire server without using command line!

**Your SMS-VTU project files are located at**: `/var/www/sms-vtu/`

## 🚀 **Next Steps After Accessing Cockpit**

1. **Explore the dashboard** - Check system resources
2. **Navigate to Files** - Browse your SMS-VTU project
3. **Check Services** - Ensure Nginx, MySQL, PHP are running
4. **Use Terminal** - Run commands directly in browser
5. **Monitor Logs** - Check system and application logs
