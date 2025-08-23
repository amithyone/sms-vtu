# Database Migration Guide

This guide will help you migrate your existing SMS app database to the new Laravel backend while preserving all user data, passwords, and balances.

## 🎯 **Migration Strategy**

**Yes, importing your current database is the BEST approach** because it will:
- ✅ Preserve all existing user passwords (if they're bcrypt hashed)
- ✅ Maintain exact user balances
- ✅ Keep all transaction history
- ✅ Preserve user relationships and data
- ✅ Allow seamless user experience

## 📋 **Prerequisites**

1. **Backup your existing database**
   ```bash
   mysqldump -u username -p your_old_database > backup_$(date +%Y%m%d_%H%M%S).sql
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
DB_USERNAME=your_username
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

Edit `laravel-backend/database/import_existing_db.php`:

```php
$config = [
    'old_database' => [
        'host' => 'localhost',
        'database' => 'your_old_database_name',  // Your existing database
        'username' => 'your_old_db_username',
        'password' => 'your_old_db_password',
        'port' => 3306
    ],
    'new_database' => [
        'host' => 'localhost',
        'database' => 'newsms_db',  // New database
        'username' => 'your_new_db_username',
        'password' => 'your_new_db_password',
        'port' => 3306
    ],
    'table_mappings' => [
        // Map your old table names to new ones
        'old_users_table' => 'users',           // Your old users table name
        'old_transactions_table' => 'transactions', // Your old transactions table
        'old_services_table' => 'services',
    ],
    'column_mappings' => [
        'users' => [
            // Map your old column names to new ones
            'old_id' => 'id',                    // Your old id column
            'old_name' => 'name',                // Your old name column
            'old_email' => 'email',              // Your old email column
            'old_phone' => 'phone',              // Your old phone column
            'old_username' => 'username',        // Your old username column
            'old_password' => 'password',        // Your old password column
            'old_balance' => 'balance',          // Your old balance column
            'old_wallet_balance' => 'wallet_balance', // Your old wallet balance
            'old_status' => 'status',            // Your old status column
            'old_role' => 'role',                // Your old role column
            'old_created_at' => 'created_at',    // Your old created_at column
            'old_updated_at' => 'updated_at',    // Your old updated_at column
        ],
        'transactions' => [
            'old_id' => 'id',
            'old_user_id' => 'user_id',
            'old_type' => 'type',
            'old_amount' => 'amount',
            'old_description' => 'description',
            'old_reference' => 'reference',
            'old_status' => 'status',
            'old_created_at' => 'created_at',
            'old_updated_at' => 'updated_at',
        ]
    ]
];
```

### Step 6: Run Import Script

```bash
cd laravel-backend
php database/import_existing_db.php
```

The script will:
- Connect to both databases
- Import users with preserved passwords
- Import transactions with references
- Generate new referral codes for users
- Skip duplicates to prevent conflicts

### Step 7: Verify Migration

```bash
# Check imported users
php artisan tinker
>>> App\Models\User::count();
>>> App\Models\User::first();

# Check imported transactions
>>> App\Models\Transaction::count();
>>> App\Models\Transaction::first();
```

### Step 8: Test User Authentication

Test that existing users can still login:

```bash
# Test API endpoint
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"existing_user@example.com","password":"existing_password"}'
```

## 🔧 **Common Migration Scenarios**

### Scenario 1: Different Password Hashing

If your old app uses a different password hashing method:

```php
// In import_existing_db.php, modify mapUserColumns()
'password' => $this->convertPasswordHash($oldUser[$mapping['old_password']] ?? ''),
```

### Scenario 2: Different Table Structure

If your old tables have different structures:

1. **Export your old table structure:**
   ```sql
   SHOW CREATE TABLE your_old_users_table;
   ```

2. **Update column mappings in the import script**

3. **Add custom mapping functions if needed**

### Scenario 3: Missing Columns

If your old database is missing some columns:

```php
// The import script will use defaults for missing columns
'wallet_balance' => $oldUser[$mapping['old_wallet_balance']] ?? 0.00,
'referral_code' => $this->generateReferralCode(), // Always generate new
```

## 🛡️ **Security Considerations**

1. **Password Preservation**: Only works if passwords are bcrypt hashed
2. **Data Validation**: Script validates data before import
3. **Duplicate Prevention**: Checks for existing users/transactions
4. **Backup**: Always backup before migration

## 🔍 **Troubleshooting**

### Issue: "Column not found"
- Check your column mappings in the import script
- Verify your old table structure

### Issue: "Password authentication failed"
- Verify password hashing method in old app
- Check if passwords are properly hashed

### Issue: "Foreign key constraint failed"
- Import users before transactions
- Check user_id references

### Issue: "Duplicate entry"
- Script automatically skips duplicates
- Check if data was partially imported before

## 📊 **Post-Migration Checklist**

- [ ] All users imported successfully
- [ ] User balances are correct
- [ ] Users can login with existing passwords
- [ ] Transaction history is preserved
- [ ] Referral codes are generated
- [ ] Admin users have correct roles
- [ ] API endpoints work correctly

## 🎉 **Benefits of This Approach**

1. **Zero Downtime**: Users can continue using existing credentials
2. **Data Integrity**: All balances and history preserved
3. **Seamless Experience**: No user re-registration required
4. **Audit Trail**: Complete transaction history maintained
5. **Scalable**: Easy to add new features to existing data

## 📞 **Support**

If you encounter issues during migration:

1. Check the Laravel logs: `storage/logs/laravel.log`
2. Verify database connections
3. Test with a small subset of data first
4. Ensure all prerequisites are installed

This migration approach ensures your users can seamlessly transition to the new app while maintaining all their existing data and credentials!
