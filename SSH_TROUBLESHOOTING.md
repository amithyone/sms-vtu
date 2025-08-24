# SSH Connection Troubleshooting Guide

## 🔍 **Understanding the "Permission Denied" Error**

The "Permission denied" error can occur for several reasons. Let's troubleshoot step by step.

## 🎯 **Quick Solutions to Try**

### Solution 1: Use Password Authentication
If you're getting permission denied with SSH keys, try using password authentication:

```bash
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no root@75.119.155.252
```

### Solution 2: Clear SSH Known Hosts
Remove the server from your known hosts and try again:

```bash
# On Windows PowerShell
ssh-keygen -R 75.119.155.252
```

### Solution 3: Try Different SSH Options
```bash
# Force password authentication
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no root@75.119.155.252

# Verbose mode to see what's happening
ssh -v root@75.119.155.252
```

## 🔧 **Server-Side Fixes**

### Check SSH Service Status
```bash
# Connect via any working method and run:
systemctl status ssh
systemctl restart ssh
```

### Verify SSH Configuration
```bash
# Check if password authentication is enabled
grep -i "PasswordAuthentication" /etc/ssh/sshd_config

# Should show: PasswordAuthentication yes
```

### Check Root Login
```bash
# Verify root can login via SSH
grep -i "PermitRootLogin" /etc/ssh/sshd_config

# Should show: PermitRootLogin yes
```

## 🛠️ **Alternative Access Methods**

### Method 1: Use PuTTY (Windows)
1. Download PuTTY from https://www.putty.org/
2. Enter: `75.119.155.252` as hostname
3. Port: `22`
4. Connection type: `SSH`
5. Click "Open"
6. Login as: `root`
7. Password: `Enter0text@@@#`

### Method 2: Use Windows Terminal
```bash
# Open Windows Terminal or PowerShell
ssh root@75.119.155.252
# When prompted, enter password: Enter0text@@@#
```

### Method 3: Use WSL (Windows Subsystem for Linux)
```bash
# If you have WSL installed
wsl
ssh root@75.119.155.252
```

## 🔍 **Diagnostic Commands**

### Check SSH Connection Verbose
```bash
ssh -v root@75.119.155.252
```

### Test Port Connectivity
```bash
# On Windows PowerShell
Test-NetConnection -ComputerName 75.119.155.252 -Port 22
```

### Check SSH Keys
```bash
# List your SSH keys
ls ~/.ssh/

# Generate new SSH key if needed
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

## 🎯 **Most Likely Solutions**

### 1. **Password Authentication Issue**
The server might be configured to only accept SSH keys. Try:
```bash
ssh -o PreferredAuthentications=password root@75.119.155.252
```

### 2. **SSH Key Mismatch**
Your SSH key might not match what's on the server. Try:
```bash
# Remove the server from known hosts
ssh-keygen -R 75.119.155.252

# Try connecting again
ssh root@75.119.155.252
```

### 3. **Firewall or Network Issue**
Check if port 22 is accessible:
```bash
# On Windows
telnet 75.119.155.252 22
```

## 🆘 **Emergency Access**

If you can't access via SSH, you might need to:

1. **Contact Contabo Support** - They can provide console access
2. **Use Contabo's Web Console** - Login to your Contabo account and use their web-based console
3. **Reset SSH Configuration** - Contact support to reset SSH settings

## ✅ **Once You're Connected**

After successfully connecting via SSH, you can:

1. **Access Cockpit**: http://75.119.155.252:9090
2. **Manage your SMS-VTU project**
3. **Configure SSH properly for future use**

## 📞 **Contact Information**

- **Contabo Support**: https://contabo.com/support/
- **Server IP**: 75.119.155.252
- **Username**: root
- **Password**: Enter0text@@@#

## 🎉 **Success Indicators**

You'll know it's working when you see:
```
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.8.0-78-generic x86_64)
root@vmi2773426:~#
```

