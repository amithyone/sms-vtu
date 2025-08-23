# SMS Service Management System

A full-stack application with React frontend and Laravel backend for managing SMS and VTU services.

## Project Structure

```
SMSnew/
├── newsms/                 # React Frontend
│   ├── src/
│   │   ├── components/     # React components
│   │   ├── services/       # API services
│   │   ├── hooks/          # Custom hooks
│   │   └── contexts/       # React contexts
│   └── package.json
└── laravel-backend/        # Laravel Backend
    ├── app/
    │   ├── Http/Controllers/
    │   └── Models/
    ├── database/migrations/
    ├── routes/
    └── config/
```

## Prerequisites

Before setting up this project, you need to install:

1. **Node.js** (v16 or higher) - [Download here](https://nodejs.org/)
2. **PHP** (v8.1 or higher) - [Download here](https://www.php.net/downloads)
3. **Composer** - [Download here](https://getcomposer.org/download/)
4. **MySQL** or **MariaDB** - [Download here](https://dev.mysql.com/downloads/)

## Setup Instructions

### 1. Frontend Setup (React)

```bash
# Navigate to the React project
cd newsms

# Install dependencies
npm install

# Start the development server
npm run dev
```

The React app will run on `http://localhost:5173`

### 2. Backend Setup (Laravel)

```bash
# Navigate to the Laravel project
cd laravel-backend

# Install PHP dependencies
composer install

# Copy environment file
cp env.example .env

# Generate application key
php artisan key:generate

# Configure your database in .env file
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=newsms_db
# DB_USERNAME=your_username
# DB_PASSWORD=your_password

# Run database migrations
php artisan migrate

# Start the Laravel development server
php artisan serve
```

The Laravel API will run on `http://localhost:8000`

### 3. Database Setup

1. Create a new MySQL database named `newsms_db`
2. Update the database credentials in `laravel-backend/.env`
3. Run migrations to create the necessary tables

## API Endpoints

### Base URL: `http://localhost:8000/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/test` | Test API connection |
| GET | `/services` | Get all services |
| POST | `/services` | Create a new service |
| PUT | `/services/{id}` | Update a service |
| DELETE | `/services/{id}` | Delete a service |

### Service Object Structure

```json
{
  "id": 1,
  "name": "Fadded VIP 🔆 Basic Service",
  "description": "Basic service package",
  "price": 29.99,
  "category": "basic",
  "is_active": true
}
```

## Features

### Frontend (React)
- ✅ Mobile-first responsive design
- ✅ Dark/Light theme support
- ✅ Service management interface
- ✅ Real-time API integration
- ✅ Custom alerts and notifications
- ✅ Search and filtering capabilities

### Backend (Laravel)
- ✅ RESTful API endpoints
- ✅ Database migrations
- ✅ CORS configuration
- ✅ Service CRUD operations
- ✅ Input validation
- ✅ Error handling

## Development

### Adding New Services

1. **Backend**: Add new service data to the `ApiController::getServices()` method
2. **Frontend**: The services will automatically appear in the UI

### Customizing Service Categories

The service categories use the "Fadded VIP 🔆" prefix as per your branding requirements. You can modify this in:
- `laravel-backend/app/Http/Controllers/ApiController.php`
- `newsms/src/components/Services.tsx`

### Styling

The project uses Tailwind CSS for styling. The mobile-first approach ensures optimal experience on mobile devices.

## Troubleshooting

### Common Issues

1. **CORS Errors**: Ensure the Laravel backend is running and CORS is properly configured
2. **Database Connection**: Verify MySQL is running and credentials are correct
3. **Port Conflicts**: Make sure ports 5173 (React) and 8000 (Laravel) are available

### Environment Variables

Make sure to set up your `.env` file in the Laravel backend with:
- Database credentials
- Application key
- CORS allowed origins

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.
