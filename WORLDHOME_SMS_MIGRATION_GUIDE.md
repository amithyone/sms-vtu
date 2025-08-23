# WorldHome SMS Database Migration Guide

This guide will help you migrate your existing WorldHome SMS database to the new Laravel backend while preserving all user data, passwords, and balances.

## 🎯 **Migration Overview**

Your existing database (`worldhome_sms`) contains:
- ✅ Users table with balances and authentication
- ✅ Transactions table with complete history
- ✅ Account details and payment methods
- ✅ Settings and configurations

## 📋 **Prerequisites**

1. **Backup your existing database**
   ```bash
   mysqldump -u root -p worldhome_sms > worldhome_sms_backup_$(date +%Y%m%d_%H%M%S).sql
   ```

2. **Install required tools**
   - PHP 8.1+
   - Composer
   - MySQL/MariaDB
   - Node.js (for React frontend)

## 🚀 **Step-by-Step Migration Process**

### Step 1: Set Up New Laravel Environment

```bash
# Navigate to your project
cd laravel-backend

# Install Laravel dependencies
composer install

# Copy environment file
cp env.example .env

# Generate application key
php artisan key:generate
```

### Step 2: Configure Database

Edit `laravel-backend/.env`:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=newsms_db
DB_USERNAME=root
DB_PASSWORD=your_password
```

### Step 3: Create New Database

```sql
CREATE DATABASE newsms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Step 4: Run Laravel Migrations

```bash
cd laravel-backend
php artisan migrate
```

This will create the new table structure:
- `users` table
- `transactions` table  
- `services` table

### Step 5: Configure Import Script

Edit `laravel-backend/database/import_worldhome_sms.php`:

```php
$config = [
    'old_database' => [
        'host' => 'localhost',
        'database' => 'worldhome_sms',  // Your existing database
        'username' => 'root',           // Your database username
        'password' => 'your_password',  // Your database password
        'port' => 3306
    ],
    'new_database' => [
        'host' => 'localhost',
        'database' => 'newsms_db',      // New database
        'username' => 'root',           // New database username
        'password' => 'your_password',  // New database password
        'port' => 3306
    ]
];
```

### Step 6: Run Import Script

```bash
cd laravel-backend
php database/import_worldhome_sms.php
```

The script will:
- ✅ Connect to both databases
- ✅ Import all users with preserved passwords
- ✅ Import all transactions with references
- ✅ Generate new referral codes for users
- ✅ Create default services with "Fadded VIP 🔆" branding
- ✅ Skip duplicates to prevent conflicts

### Step 7: Verify Migration

```bash
# Check imported users
php artisan tinker
>>> App\Models\User::count();
>>> App\Models\User::first();

# Check imported transactions
>>> App\Models\Transaction::count();
>>> App\Models\Transaction::first();

# Check services
>>> App\Models\Service::count();
>>> App\Models\Service::all();
```

### Step 8: Test User Authentication

Test that existing users can still login:

```bash
# Test API endpoint
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"existing_user@example.com","password":"existing_password"}'
```

## 🔧 **Column Mapping**

The import script automatically maps your existing columns:

### Users Table Mapping:
- `id` → `id`
- `name` → `name`
- `email` → `email`
- `phone/mobile` → `phone`
- `username` → `username`
- `password` → `password` (preserved hash)
- `balance/wallet_balance` → `balance`
- `status/is_active` → `status`
- `role/user_type` → `role`

### Transactions Table Mapping:
- `id` → `id`
- `user_id/userid` → `user_id`
- `type/transaction_type` → `type`
- `amount` → `amount`
- `description/narration` → `description`
- `reference/ref` → `reference`
- `status` → `status`

## 🛡️ **Security Features**

1. **Password Preservation**: Maintains existing bcrypt hashes
2. **Data Validation**: Validates all data before import
3. **Duplicate Prevention**: Checks for existing users/transactions
4. **Safe Migration**: No data loss or corruption

## 📊 **Post-Migration Checklist**

- [ ] All users imported successfully
- [ ] User balances are correct
- [ ] Users can login with existing credentials
- [ ] Transaction history is preserved
- [ ] Referral codes are generated
- [ ] Admin users have correct roles
- [ ] Services are created with "Fadded VIP 🔆" branding
- [ ] API endpoints work correctly

## 🎉 **Benefits of This Migration**

1. **Zero Downtime**: Users can continue using existing credentials
2. **Data Integrity**: All balances and history preserved
3. **Seamless Experience**: No user re-registration required
4. **Audit Trail**: Complete transaction history maintained
5. **Mobile-First**: React frontend works perfectly
6. **Scalable**: Easy to add new features

## 🚀 **Start Your New Application**

### Start Laravel Backend:
```bash
cd laravel-backend
php artisan serve
```

### Start React Frontend:
```bash
cd newsms
npm run dev
```

### Access Your Application:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/api/test

## 🔍 **Troubleshooting**

### Issue: "Database connection failed"
- Verify database credentials in the import script
- Ensure MySQL is running
- Check database names are correct

### Issue: "Column not found"
- The script handles multiple column name variations
- Check if your database structure is different

### Issue: "Password authentication failed"
- Verify passwords are bcrypt hashed in your old database
- Check if password column name is different

### Issue: "Foreign key constraint failed"
- Import users before transactions
- Check user_id references

## 📞 **Support**

If you encounter issues:

1. Check Laravel logs: `storage/logs/laravel.log`
2. Verify database connections
3. Test with a small subset of data first
4. Ensure all prerequisites are installed

## 🎯 **Next Steps After Migration**

1. **Test the complete system**
2. **Update any missing user data**
3. **Configure additional services**
4. **Set up payment gateways**
5. **Deploy to production**

This migration ensures your WorldHome SMS users can seamlessly transition to the new app while maintaining all their existing data, passwords, and balances!
