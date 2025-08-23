# iRecharge VTU Integration Guide

This guide covers the complete integration of iRecharge API for VTU (Virtual Top-Up) services in your WorldHome SMS application.

## 🎯 **Overview**

Your application now supports comprehensive VTU services powered by iRecharge:

### **Services Available** 🚀
- **Airtime Purchase** - Instant airtime to all Nigerian networks
- **Data Bundle Purchase** - Data bundles for all networks
- **Phone Number Validation** - Real-time validation for network compatibility
- **Transaction Status Tracking** - Monitor purchase status
- **Provider Balance Monitoring** - Track iRecharge account balance

## 🚀 **Quick Setup**

### **1. Backend Configuration**

Add iRecharge credentials to your `.env` file:

```env
# iRecharge API Configuration
IRECHARGE_BASE_URL=https://irecharge.com.ng/pwr_api_sandbox/
IRECHARGE_USERNAME=your_irecharge_username
IRECHARGE_PASSWORD=your_irecharge_password
```

### **2. API Endpoints**

#### **Airtime Networks**
```http
GET /api/vtu/airtime/networks
```
Returns available networks for airtime purchase.

#### **Data Networks**
```http
GET /api/vtu/data/networks
```
Returns available networks for data bundle purchase.

#### **Data Bundles**
```http
GET /api/vtu/data/bundles?network={network_code}
```
Returns available data bundles for a specific network.

#### **Purchase Airtime**
```http
POST /api/vtu/airtime/purchase
Content-Type: application/json
Authorization: Bearer {token}

{
  "network": "mtn",
  "phone": "08012345678",
  "amount": 1000
}
```

#### **Purchase Data Bundle**
```http
POST /api/vtu/data/purchase
Content-Type: application/json
Authorization: Bearer {token}

{
  "network": "mtn",
  "phone": "08012345678",
  "plan": "plan_id",
  "plan_name": "1GB - 30 Days",
  "amount": 350
}
```

#### **Validate Phone Number**
```http
POST /api/vtu/validate/phone
Content-Type: application/json
Authorization: Bearer {token}

{
  "phone": "08012345678",
  "network": "mtn"
}
```

#### **Transaction Status**
```http
GET /api/vtu/transaction/status?reference={reference}
```

#### **Provider Balance**
```http
GET /api/vtu/provider/balance
```

## 🔧 **Backend Implementation**

### **1. iRecharge Service (`IrechargeService.php`)**

The service handles all iRecharge API interactions:

```php
class IrechargeService
{
    // Get airtime networks
    public function getAirtimeNetworks(): array
    
    // Get data networks
    public function getDataNetworks(): array
    
    // Get data bundles for network
    public function getDataBundles(string $network): array
    
    // Purchase airtime
    public function purchaseAirtime(string $network, string $phone, float $amount, string $reference): array
    
    // Purchase data bundle
    public function purchaseDataBundle(string $network, string $phone, string $plan, string $reference): array
    
    // Get transaction status
    public function getTransactionStatus(string $reference): array
    
    // Get account balance
    public function getBalance(): array
    
    // Validate phone number
    public function validatePhoneNumber(string $phone, string $network): bool
}
```

### **2. VTU Controller (`VtuController.php`)**

Handles all VTU-related API endpoints with:
- User authentication
- Balance validation
- Transaction recording
- Error handling

### **3. Database Integration**

Transactions are automatically recorded in the `transactions` table with:
- User balance updates
- Transaction metadata
- Reference tracking

## 🎨 **Frontend Implementation**

### **1. VTU API Service (`vtuApi.ts`)**

```typescript
class VtuApiService {
  // Get airtime networks
  async getAirtimeNetworks(): Promise<VtuNetwork[]>
  
  // Get data networks
  async getDataNetworks(): Promise<VtuNetwork[]>
  
  // Get data bundles
  async getDataBundles(network: string): Promise<VtuDataBundle[]>
  
  // Purchase airtime
  async purchaseAirtime(request: VtuPurchaseRequest): Promise<VtuPurchaseResponse>
  
  // Purchase data bundle
  async purchaseDataBundle(request: VtuPurchaseRequest): Promise<VtuPurchaseResponse>
  
  // Get transaction status
  async getTransactionStatus(reference: string): Promise<VtuTransactionStatus>
  
  // Validate phone number
  async validatePhoneNumber(phone: string, network: string): Promise<ValidationResult>
}
```

### **2. VTU Hook (`useVtu.ts`)**

React hook for managing VTU state and actions:

```typescript
const {
  // Networks
  airtimeNetworks,
  dataNetworks,
  loadingNetworks,
  
  // Data Bundles
  dataBundles,
  loadingBundles,
  
  // Actions
  purchaseAirtime,
  purchaseDataBundle,
  validatePhoneNumber
} = useVtu();
```

### **3. UI Components**

#### **AirtimeModal**
- Network selection with real-time availability
- Phone number validation
- Amount input with validation
- Purchase processing with feedback

#### **DataBundleModal**
- Network selection
- Dynamic bundle loading
- Bundle selection with details
- Phone validation and purchase

## 📱 **User Experience Features**

### **1. Real-time Validation**
- Phone number format validation
- Network compatibility checking
- Balance verification

### **2. Smart UI**
- Loading states for all operations
- Error handling with user-friendly messages
- Success confirmations with transaction references

### **3. Mobile-First Design**
- Responsive grid layouts
- Touch-friendly buttons
- Optimized for mobile screens

## 🔒 **Security & Validation**

### **1. Input Validation**
- Phone number format (11 digits)
- Amount limits (₦50 - ₦50,000)
- Network-specific phone validation

### **2. Balance Protection**
- Pre-purchase balance checks
- Transaction rollback on failure
- User balance updates

### **3. Error Handling**
- Comprehensive error logging
- User-friendly error messages
- Graceful failure recovery

## 📊 **Transaction Flow**

### **Airtime Purchase**
1. User selects network
2. Enters phone number (auto-validated)
3. Enters amount
4. System validates balance
5. Purchase processed via iRecharge
6. Transaction recorded
7. User balance updated
8. Success confirmation

### **Data Bundle Purchase**
1. User selects network
2. System loads available bundles
3. User selects bundle
4. Enters phone number (auto-validated)
5. System validates balance
6. Purchase processed via iRecharge
7. Transaction recorded
8. User balance updated
9. Success confirmation

## 🚀 **Testing**

### **1. Backend Testing**
```bash
# Test airtime networks
curl -X GET "http://localhost:8000/api/vtu/airtime/networks" \
  -H "Authorization: Bearer {token}"

# Test airtime purchase
curl -X POST "http://localhost:8000/api/vtu/airtime/purchase" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "network": "mtn",
    "phone": "08012345678",
    "amount": 100
  }'
```

### **2. Frontend Testing**
- Test network loading
- Test phone validation
- Test purchase flow
- Test error scenarios

## 🔧 **Configuration**

### **Environment Variables**
```env
IRECHARGE_BASE_URL=https://irecharge.com.ng/pwr_api_sandbox/
IRECHARGE_USERNAME=your_username
IRECHARGE_PASSWORD=your_password
```

### **Network Configuration**
The system supports all major Nigerian networks:
- MTN
- Airtel
- Glo
- 9mobile

## 📈 **Monitoring & Analytics**

### **1. Transaction Tracking**
- All purchases logged with references
- Success/failure rates
- Response times
- Error patterns

### **2. Balance Monitoring**
- Real-time provider balance
- User balance tracking
- Transaction history

## 🎉 **Next Steps**

1. **Configure iRecharge Credentials**
   - Add your iRecharge username and password to `.env`
   - Test API connectivity

2. **Test the Integration**
   - Test airtime purchases
   - Test data bundle purchases
   - Verify phone validation

3. **Monitor Transactions**
   - Check transaction logs
   - Monitor success rates
   - Track user feedback

4. **Scale & Optimize**
   - Add more networks if needed
   - Optimize response times
   - Add additional features

## 🆘 **Troubleshooting**

### **Common Issues**

1. **API Connection Failed**
   - Check iRecharge credentials
   - Verify network connectivity
   - Check API endpoint URLs

2. **Phone Validation Fails**
   - Ensure phone number is 11 digits
   - Check network compatibility
   - Verify iRecharge API response

3. **Purchase Fails**
   - Check user balance
   - Verify network availability
   - Check iRecharge account balance

### **Support**
For iRecharge API support, contact their technical team or refer to their API documentation.

---

**🎉 Your VTU system is now fully integrated with iRecharge!**

Users can now purchase airtime and data bundles instantly through your platform with real-time validation and seamless user experience.
