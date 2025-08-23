# SMS API Integration Guide - Auto & Manual Modes

This guide covers the complete SMS service integration with dual-mode functionality for your WorldHome SMS application.

## 🎯 **Overview**

Your SMS system now supports two distinct modes:

### **Auto Mode** 🚀
- **"Virtual Verify Number"** button on home page
- System automatically selects the best available provider
- Based on success rates, availability, and priority
- Optimal for users who want the fastest, most reliable service
- No provider selection required

### **Manual Mode** 🎯
- **"Choose Server"** button on home page
- Users manually select their preferred SMS provider
- Full control over which provider to use
- Shows real-time provider statistics and availability
- Ideal for users with specific provider preferences

## 🚀 **Quick Setup**

### 1. **Install Dependencies**
```bash
cd laravel-backend
composer install
```

### 2. **Run Migrations**
```bash
php artisan migrate
```

### 3. **Seed SMS Services**
```bash
php artisan db:seed --class=SmsServiceSeeder
```

### 4. **Configure API Keys**
Edit `laravel-backend/.env`:
```env
# SMS Provider API Keys
5SIM_API_KEY=your_5sim_api_key_here
DASSY_API_KEY=your_dassy_api_key_here
TIGER_SMS_API_KEY=your_tiger_sms_api_key_here
```

## 📡 **API Endpoints**

### **Protected Endpoints** (Require Bearer Token)

#### **1. Get Available Countries**
```http
GET /api/sms/countries
Authorization: Bearer {token}
```

#### **2. Get Services for Country**
```http
GET /api/sms/services?country=US&provider=5sim
Authorization: Bearer {token}
```

#### **3. Get Available Providers (Manual Mode)**
```http
GET /api/sms/providers
Authorization: Bearer {token}
```

#### **4. Create SMS Order**
```http
POST /api/sms/order
Authorization: Bearer {token}
Content-Type: application/json

# Auto Mode
{
  "country": "US",
  "service": "google",
  "mode": "auto"
}

# Manual Mode
{
  "country": "US",
  "service": "google",
  "mode": "manual",
  "provider": "5sim"
}
```

#### **5. Get SMS Code**
```http
GET /api/sms/code?order_id=SMS_ABC123DEF
Authorization: Bearer {token}
```

#### **6. Cancel Order**
```http
POST /api/sms/cancel
Authorization: Bearer {token}
Content-Type: application/json
{
  "order_id": "SMS_ABC123DEF"
}
```

#### **7. Get User Orders**
```http
GET /api/sms/orders?status=completed&limit=10
Authorization: Bearer {token}
```

#### **8. Get SMS Statistics**
```http
GET /api/sms/stats
Authorization: Bearer {token}
```

## 🔧 **Frontend Integration**

### **Auto Mode Flow**
1. User clicks **"Virtual Verify Number"**
2. System shows available countries
3. User selects country
4. System shows available services
5. User selects service
6. System automatically selects best provider
7. Order is created and SMS code is polled

### **Manual Mode Flow**
1. User clicks **"Choose Server"**
2. System shows available providers with stats
3. User selects preferred provider
4. System shows available countries for that provider
5. User selects country
6. System shows available services for that provider/country
7. User selects service
8. Order is created with selected provider
9. SMS code is polled

### **React Hook Usage**
```typescript
import { useSms } from '../hooks/useSms';

function SmsComponent() {
  const {
    countries,
    services,
    providers,
    loadingCountries,
    loadingServices,
    loadingProviders,
    createOrder,
    getSmsCode,
    cancelOrder,
    pollForSmsCode
  } = useSms();

  // Auto mode - system selects best provider
  const handleAutoMode = async () => {
    const order = await createOrder('US', 'google', 'auto');
    const smsCode = await pollForSmsCode(order.order_id);
  };

  // Manual mode - user selects specific provider
  const handleManualMode = async () => {
    const order = await createOrder('US', 'google', 'manual', '5sim');
    const smsCode = await pollForSmsCode(order.order_id);
  };
}
```

### **Direct API Service Usage**
```typescript
import { smsApiService } from '../services/smsApi';

// Auto mode
const autoOrder = await smsApiService.createOrder('US', 'google', 'auto');
const autoSmsCode = await smsApiService.pollForSmsCode(autoOrder.order_id);

// Manual mode
const manualOrder = await smsApiService.createOrder('US', 'google', 'manual', '5sim');
const manualSmsCode = await smsApiService.pollForSmsCode(manualOrder.order_id);

// Get providers for manual selection
const providers = await smsApiService.getProviders();
```

## 🎨 **UI Components**

### **Auto Mode Modal** (`VirtualNumberModal.tsx`)
- Simplified flow: Country → Service → Auto Provider Selection
- Shows "Auto Mode" branding
- Automatic provider selection
- Real-time SMS polling

### **Manual Mode Modal** (`ServerSelectionModal.tsx`)
- Provider selection with statistics
- Success rates, total orders, availability
- Real-time provider status
- Manual control over provider choice

## 🔒 **Security Features**

### **Authentication**
- All SMS endpoints require Bearer token authentication
- User-specific order tracking
- Balance validation before order creation

### **Provider Management**
- Real-time provider availability checking
- Automatic fallback in auto mode
- Provider balance monitoring
- Success rate tracking

### **Order Security**
- Unique order IDs for each request
- User-specific order isolation
- Automatic order expiration
- Secure SMS code delivery

## 📊 **Provider Statistics**

### **Real-time Metrics**
- **Success Rate**: Percentage of successful orders
- **Total Orders**: Number of orders processed
- **Successful Orders**: Number of completed orders
- **Balance**: Current provider balance
- **Last Updated**: Timestamp of last balance check

### **Provider Status**
- **Available**: Provider has sufficient balance and is operational
- **Low Balance**: Provider balance is low, may be unavailable
- **Offline**: Provider is temporarily unavailable

## 🌍 **Supported Services**

### **Popular Services**
- **WhatsApp**: WhatsApp verification
- **Telegram**: Telegram verification
- **Instagram**: Instagram verification
- **Facebook**: Facebook verification
- **Twitter/X**: Twitter verification
- **Google**: Google verification
- **Discord**: Discord verification
- **TikTok**: TikTok verification

### **Countries**
- **United States**: US phone numbers
- **United Kingdom**: UK phone numbers
- **Canada**: Canadian phone numbers
- **Australia**: Australian phone numbers
- **Germany**: German phone numbers
- **France**: French phone numbers
- **India**: Indian phone numbers
- **Nigeria**: Nigerian phone numbers

## 🔄 **Order Lifecycle**

### **1. Order Creation**
- User selects country and service
- System validates user balance
- Provider is selected (auto or manual)
- Order is created in database
- User balance is deducted

### **2. SMS Reception**
- System polls for SMS code
- Real-time status updates
- Automatic code detection
- Order status updates

### **3. Order Completion**
- SMS code is delivered to user
- Order marked as completed
- Success rate updated
- Transaction recorded

### **4. Order Cancellation**
- User can cancel pending orders
- Balance is refunded
- Order marked as cancelled
- Provider is notified

## 🛠 **Troubleshooting**

### **Common Issues**

#### **Provider Unavailable**
- Check provider balance in admin panel
- Verify API keys are correct
- Check provider status in real-time

#### **SMS Code Not Received**
- Verify order is still active
- Check provider availability
- Ensure correct phone number format

#### **Balance Issues**
- Verify user has sufficient balance
- Check for pending transactions
- Validate balance calculation

### **Monitoring**

#### **Admin Dashboard**
- Real-time provider statistics
- Order success rates
- Balance monitoring
- Error tracking

#### **User Dashboard**
- Order history
- Balance tracking
- Success rate display
- Provider performance

## 📈 **Performance Optimization**

### **Auto Mode Optimization**
- Provider selection based on success rate
- Real-time availability checking
- Automatic failover to backup providers
- Load balancing across providers

### **Manual Mode Optimization**
- Provider statistics caching
- Real-time status updates
- Performance metrics display
- User preference learning

## 🚀 **Next Steps**

1. **Configure API Keys**: Add your SMS provider API keys
2. **Test Both Modes**: Verify auto and manual modes work correctly
3. **Monitor Performance**: Track success rates and provider performance
4. **User Training**: Educate users on the difference between modes
5. **Scale Up**: Add more providers as needed

## 📞 **Support**

For technical support or questions about the SMS integration:
- Check the troubleshooting section above
- Review provider documentation
- Monitor real-time provider status
- Contact your SMS provider support

---

**🎉 Your SMS system is now ready with both auto and manual modes!**
