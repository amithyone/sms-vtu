# SMS Application - Coolify Deployment Guide

## Overview
This guide explains how to deploy your SMS application (Laravel Backend + React Frontend) to Coolify using the monorepo approach.

## Project Structure
```
SMSnew/
├── laravel-backend/     # Laravel API
├── newsms/             # React Frontend
├── docker-compose.yml  # Multi-service configuration
├── nginx.conf         # Reverse proxy configuration
└── .coolifyignore     # Files to exclude from deployment
```

## Prerequisites
- ✅ Coolify installed on your server
- ✅ Git repository with your code
- ✅ Domain name (optional but recommended)

## Deployment Steps

### 1. Access Coolify Dashboard
- Open your browser and go to: `http://75.119.155.252:8000`
- Complete the initial setup if this is your first time

### 2. Create a New Project
1. Click "New Project" in Coolify dashboard
2. Choose "Application" type
3. Select "Docker Compose" as deployment method
4. Connect your Git repository

### 3. Configure Repository
- **Repository URL**: Your Git repository URL
- **Branch**: `main` or `master`
- **Root Directory**: `/` (root of repository)

### 4. Environment Variables
Add these environment variables in Coolify:

#### Laravel Backend Variables:
```
APP_NAME=SMS Application
APP_ENV=production
APP_DEBUG=false
APP_URL=https://yourdomain.com
APP_KEY=base64:your-generated-key

DB_CONNECTION=mysql
DB_HOST=your-database-host
DB_PORT=3306
DB_DATABASE=your-database-name
DB_USERNAME=your-database-user
DB_PASSWORD=your-database-password

CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
```

#### React Frontend Variables:
```
VITE_API_URL=https://api.yourdomain.com
VITE_APP_NAME=SMS Application
```

### 5. Build Configuration
- **Build Command**: Leave empty (handled by Docker)
- **Start Command**: Leave empty (handled by Docker)
- **Port**: 80 (for nginx reverse proxy)

### 6. Domain Configuration
Configure your domains in Coolify:
- **Frontend**: `yourdomain.com` → Port 80
- **API**: `api.yourdomain.com` → Port 80

### 7. Deploy
1. Click "Deploy" to start the build process
2. Monitor the build logs for any issues
3. Wait for all services to be healthy

## Service Architecture

### Services Overview:
1. **nginx** (Port 80/443) - Reverse proxy
2. **laravel-api** (Port 8000) - Laravel backend
3. **react-frontend** (Port 3000) - React frontend

### Network Flow:
```
Internet → nginx:80 → react-frontend:3000 (Frontend)
Internet → nginx:80 → laravel-api:8000 (API)
```

## Troubleshooting

### Common Issues:

#### 1. Build Failures
- Check Dockerfile syntax
- Verify all required files exist
- Check build logs in Coolify

#### 2. Database Connection Issues
- Verify database credentials
- Check if database is accessible from container
- Ensure database migrations are run

#### 3. Frontend API Calls Failing
- Verify `VITE_API_URL` environment variable
- Check CORS configuration in Laravel
- Ensure API routes are working

#### 4. Port Conflicts
- Ensure ports 80, 3000, 8000 are available
- Check if other services are using these ports

### Debugging Commands:
```bash
# Check container status
docker ps

# View container logs
docker logs sms-nginx
docker logs sms-laravel-api
docker logs sms-react-frontend

# Access container shell
docker exec -it sms-laravel-api bash
docker exec -it sms-react-frontend sh
```

## SSL/HTTPS Setup
1. In Coolify, go to your project settings
2. Add SSL certificate (Let's Encrypt or custom)
3. Configure automatic redirects from HTTP to HTTPS

## Monitoring & Maintenance

### Health Checks:
- Frontend: `https://yourdomain.com`
- API: `https://api.yourdomain.com/api/health`

### Backup Strategy:
- Database: Regular MySQL backups
- Files: Volume backups for Laravel storage
- Environment: Export environment variables

### Updates:
1. Push changes to Git repository
2. Coolify will automatically detect changes
3. Redeploy through Coolify dashboard

## Performance Optimization

### Laravel Backend:
- Enable OPcache
- Use Redis for caching
- Optimize database queries
- Enable route caching

### React Frontend:
- Enable gzip compression
- Use CDN for static assets
- Implement lazy loading
- Optimize bundle size

## Security Considerations

### Laravel:
- Set `APP_DEBUG=false` in production
- Use strong `APP_KEY`
- Configure proper CORS settings
- Enable HTTPS only

### React:
- Validate all API inputs
- Implement proper authentication
- Use environment variables for sensitive data
- Regular dependency updates

## Support
If you encounter issues:
1. Check Coolify logs
2. Review Docker container logs
3. Verify environment variables
4. Test services individually

## Next Steps
After successful deployment:
1. Set up monitoring and alerts
2. Configure automated backups
3. Set up CI/CD pipeline
4. Implement logging and analytics
