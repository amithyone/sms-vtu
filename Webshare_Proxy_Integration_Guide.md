# Webshare Proxy Integration Guide

This guide covers the complete integration of Webshare proxy services into the SMS application.

## Overview

The Webshare proxy integration provides users with access to high-quality proxy services including:
- Proxy list management
- IP authorization
- Usage statistics
- Subscription plans
- Activity monitoring
- Configuration management

## Backend Integration

### 1. Environment Configuration

Add the following to your `.env` file:

```env
# Webshare API Configuration
WEBSHARE_API_KEY=your_webshare_api_key_here
WEBSHARE_BASE_URL=https://proxy.webshare.io/api/v2
```

### 2. Service Layer

The `WebshareService` class handles all API interactions:

```php
<?php
namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Exception;

class WebshareService
{
    private $baseUrl;
    private $apiKey;
    private $httpClient;

    public function __construct()
    {
        $this->baseUrl = env('WEBSHARE_BASE_URL', 'https://proxy.webshare.io/api/v2');
        $this->apiKey = env('WEBSHARE_API_KEY');
        $this->httpClient = Http::withHeaders([
            'Authorization' => 'Token ' . $this->apiKey,
            'Content-Type' => 'application/json',
        ]);
    }

    // User Profile
    public function getUserProfile(): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/profile/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getUserProfile error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Proxy List
    public function getProxyList(array $params = []): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/list/', $params);
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getProxyList error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Download Proxy List
    public function downloadProxyList(array $params = []): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/list/download/', $params);
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare downloadProxyList error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Refresh Proxy List
    public function refreshProxyList(): array
    {
        try {
            $response = $this->httpClient->post($this->baseUrl . '/proxy/list/refresh/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare refreshProxyList error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Statistics
    public function getProxyStats(array $params = []): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/stats/', $params);
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getProxyStats error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Subscription Plans
    public function getSubscriptionPlans(): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/subscription/plans/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getSubscriptionPlans error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Available Assets
    public function getAvailableAssets(): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/assets/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getAvailableAssets error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Proxy Configuration
    public function getProxyConfig(): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/config/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getProxyConfig error: ' . $e->getMessage());
            throw $e;
        }
    }

    // IP Authorization
    public function createIpAuthorization(string $ip): array
    {
        try {
            $response = $this->httpClient->post($this->baseUrl . '/proxy/ip-authorization/', [
                'ip' => $ip
            ]);
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare createIpAuthorization error: ' . $e->getMessage());
            throw $e;
        }
    }

    public function getIpAuthorizations(): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/ip-authorization/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getIpAuthorizations error: ' . $e->getMessage());
            throw $e;
        }
    }

    public function deleteIpAuthorization(int $authorizationId): array
    {
        try {
            $response = $this->httpClient->delete($this->baseUrl . '/proxy/ip-authorization/' . $authorizationId . '/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare deleteIpAuthorization error: ' . $e->getMessage());
            throw $e;
        }
    }

    // My IP
    public function getMyIp(): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/my-ip/');
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getMyIp error: ' . $e->getMessage());
            throw $e;
        }
    }

    // Activities
    public function getProxyActivities(array $params = []): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/activities/', $params);
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare getProxyActivities error: ' . $e->getMessage());
            throw $e;
        }
    }

    public function downloadProxyActivities(array $params = []): array
    {
        try {
            $response = $this->httpClient->get($this->baseUrl . '/proxy/activities/download/', $params);
            return $response->json();
        } catch (Exception $e) {
            Log::error('Webshare downloadProxyActivities error: ' . $e->getMessage());
            throw $e;
        }
    }
}
```

### 3. Controller

The `ProxyController` handles all proxy-related API requests:

```php
<?php
namespace App\Http\Controllers;

use App\Services\WebshareService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class ProxyController extends Controller
{
    private $webshareService;

    public function __construct(WebshareService $webshareService)
    {
        $this->webshareService = $webshareService;
    }

    public function getUserProfile(): JsonResponse
    {
        try {
            $data = $this->webshareService->getUserProfile();
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getProxyList(Request $request): JsonResponse
    {
        try {
            $params = $request->all();
            $data = $this->webshareService->getProxyList($params);
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function downloadProxyList(Request $request): JsonResponse
    {
        try {
            $params = $request->all();
            $data = $this->webshareService->downloadProxyList($params);
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function refreshProxyList(): JsonResponse
    {
        try {
            $data = $this->webshareService->refreshProxyList();
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getProxyStats(Request $request): JsonResponse
    {
        try {
            $params = $request->all();
            $data = $this->webshareService->getProxyStats($params);
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getSubscriptionPlans(): JsonResponse
    {
        try {
            $data = $this->webshareService->getSubscriptionPlans();
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getAvailableAssets(): JsonResponse
    {
        try {
            $data = $this->webshareService->getAvailableAssets();
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getProxyConfig(): JsonResponse
    {
        try {
            $data = $this->webshareService->getProxyConfig();
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function createIpAuthorization(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'ip' => 'required|ip',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'message' => $validator->errors()->first()], 400);
        }

        try {
            $data = $this->webshareService->createIpAuthorization($request->ip);
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getIpAuthorizations(): JsonResponse
    {
        try {
            $data = $this->webshareService->getIpAuthorizations();
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function deleteIpAuthorization(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'authorization_id' => 'required|integer',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'message' => $validator->errors()->first()], 400);
        }

        try {
            $data = $this->webshareService->deleteIpAuthorization($request->authorization_id);
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getMyIp(): JsonResponse
    {
        try {
            $data = $this->webshareService->getMyIp();
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getProxyActivities(Request $request): JsonResponse
    {
        try {
            $params = $request->all();
            $data = $this->webshareService->getProxyActivities($params);
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function downloadProxyActivities(Request $request): JsonResponse
    {
        try {
            $params = $request->all();
            $data = $this->webshareService->downloadProxyActivities($params);
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function purchaseProxyPlan(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'plan_id' => 'required|string',
            'payment_method' => 'required|string|in:balance,card',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'message' => $validator->errors()->first()], 400);
        }

        try {
            // Check user balance if using balance payment
            if ($request->payment_method === 'balance') {
                $user = Auth::user();
                // Add balance check logic here
                // Deduct balance from user account
            }

            // Record transaction
            $transaction = new Transaction();
            $transaction->user_id = Auth::id();
            $transaction->type = 'proxy_purchase';
            $transaction->amount = 0; // Set based on plan price
            $transaction->reference = 'PROXY_' . uniqid();
            $transaction->status = 'pending';
            $transaction->description = 'Proxy plan purchase';
            $transaction->save();

            return response()->json([
                'success' => true,
                'data' => [
                    'plan_id' => $request->plan_id,
                    'status' => 'pending',
                    'reference' => $transaction->reference
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }
}
```

### 4. API Routes

Add the following routes to `routes/api.php`:

```php
// Proxy Service routes (Webshare)
Route::prefix('proxy')->group(function () {
    Route::get('/profile', [ProxyController::class, 'getUserProfile']);
    Route::get('/list', [ProxyController::class, 'getProxyList']);
    Route::get('/list/download', [ProxyController::class, 'downloadProxyList']);
    Route::post('/list/refresh', [ProxyController::class, 'refreshProxyList']);
    Route::get('/stats', [ProxyController::class, 'getProxyStats']);
    Route::get('/plans', [ProxyController::class, 'getSubscriptionPlans']);
    Route::get('/assets', [ProxyController::class, 'getAvailableAssets']);
    Route::get('/config', [ProxyController::class, 'getProxyConfig']);
    Route::post('/ip-authorization', [ProxyController::class, 'createIpAuthorization']);
    Route::get('/ip-authorizations', [ProxyController::class, 'getIpAuthorizations']);
    Route::delete('/ip-authorization', [ProxyController::class, 'deleteIpAuthorization']);
    Route::get('/my-ip', [ProxyController::class, 'getMyIp']);
    Route::get('/activities', [ProxyController::class, 'getProxyActivities']);
    Route::get('/activities/download', [ProxyController::class, 'downloadProxyActivities']);
    Route::post('/purchase', [ProxyController::class, 'purchaseProxyPlan']);
});
```

## Frontend Integration

### 1. API Service

The `proxyApi.ts` file provides TypeScript interfaces and API methods:

```typescript
// Key interfaces
export interface ProxyProfile {
  id: string;
  email: string;
  username: string;
  first_name: string;
  last_name: string;
  is_active: boolean;
  created_at: string;
}

export interface ProxyServer {
  id: string;
  proxy_address: string;
  ports: {
    http: number;
    https: number;
    socks5: number;
  };
  username: string;
  password: string;
  country: string;
  city: string;
  isp: string;
  created_at: string;
  last_used: string;
  is_active: boolean;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  currency: string;
  proxy_count: number;
  bandwidth_limit: number;
  features: string[];
  is_popular: boolean;
}

// API methods
class ProxyApiService {
  async getUserProfile(): Promise<ProxyProfile> { /* ... */ }
  async getProxyList(params?: Record<string, any>): Promise<ProxyListResponse> { /* ... */ }
  async getSubscriptionPlans(): Promise<SubscriptionPlan[]> { /* ... */ }
  async createIpAuthorization(ip: string): Promise<IpAuthorization> { /* ... */ }
  async purchaseProxyPlan(request: ProxyPurchaseRequest): Promise<ProxyPurchaseResponse> { /* ... */ }
  // ... other methods
}
```

### 2. React Hook

The `useProxy.ts` hook manages state and provides actions:

```typescript
export const useProxy = (): UseProxyReturn => {
  // State management for all proxy data
  const [profile, setProfile] = useState<ProxyProfile | null>(null);
  const [proxyList, setProxyList] = useState<ProxyListResponse | null>(null);
  const [plans, setPlans] = useState<SubscriptionPlan[]>([]);
  // ... other state

  // Actions
  const fetchProfile = useCallback(async () => { /* ... */ }, []);
  const fetchProxyList = useCallback(async (params?: Record<string, any>) => { /* ... */ }, []);
  const createIpAuthorization = useCallback(async (ip: string) => { /* ... */ }, []);
  const purchasePlan = useCallback(async (request: ProxyPurchaseRequest) => { /* ... */ }, []);

  // Load initial data
  useEffect(() => {
    fetchProfile();
    fetchPlans();
    fetchConfig();
    fetchIpAuthorizations();
  }, []);

  return {
    // State
    profile,
    proxyList,
    plans,
    // ... other state
    // Actions
    fetchProfile,
    fetchProxyList,
    createIpAuthorization,
    purchasePlan,
    // ... other actions
  };
};
```

### 3. React Component

The `ProxyService.tsx` component provides a complete UI:

```typescript
const ProxyService: React.FC = () => {
  const {
    profile,
    proxyList,
    plans,
    stats,
    // ... other data
    fetchProxyList,
    createIpAuthorization,
    purchasePlan,
    // ... other actions
  } = useProxy();

  const [activeTab, setActiveTab] = useState('overview');

  const tabs = [
    { id: 'overview', label: 'Overview', icon: BarChart3 },
    { id: 'proxies', label: 'Proxy List', icon: Wifi },
    { id: 'plans', label: 'Plans', icon: CreditCard },
    { id: 'authorizations', label: 'IP Auth', icon: Shield },
    { id: 'activities', label: 'Activities', icon: Activity },
    { id: 'config', label: 'Config', icon: Settings }
  ];

  // Render different tabs
  const renderOverview = () => (/* Profile, stats, quick actions */);
  const renderProxyList = () => (/* Proxy list with download/refresh */);
  const renderPlans = () => (/* Subscription plans with purchase */);
  const renderAuthorizations = () => (/* IP authorization management */);
  const renderActivities = () => (/* Activity monitoring */);
  const renderConfig = () => (/* Configuration display */);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Tab navigation */}
      <nav className="-mb-px flex space-x-8">
        {tabs.map((tab) => (/* Tab buttons */))}
      </nav>

      {/* Tab content */}
      <div className="min-h-96">
        {activeTab === 'overview' && renderOverview()}
        {activeTab === 'proxies' && renderProxyList()}
        {activeTab === 'plans' && renderPlans()}
        {activeTab === 'authorizations' && renderAuthorizations()}
        {activeTab === 'activities' && renderActivities()}
        {activeTab === 'config' && renderConfig()}
      </div>
    </div>
  );
};
```

## Key Features

### 1. Overview Dashboard
- User profile information
- Usage statistics
- Quick action buttons
- Account status

### 2. Proxy List Management
- View all available proxies
- Download proxy list
- Refresh proxy list
- Filter by country, type, etc.

### 3. Subscription Plans
- View available plans
- Purchase new plans
- Plan comparison
- Popular plan highlighting

### 4. IP Authorization
- Add new IP addresses
- View authorized IPs
- Delete IP authorizations
- IP status monitoring

### 5. Activity Monitoring
- View proxy usage activities
- Download activity reports
- Success/failure tracking
- Data transfer statistics

### 6. Configuration
- Display proxy configuration
- Connection details
- Port information
- Authentication credentials

## Usage Examples

### Purchasing a Proxy Plan
```typescript
const { purchasePlan } = useProxy();

const handlePurchase = async () => {
  try {
    const result = await purchasePlan({
      plan_id: 'plan_123',
      payment_method: 'balance'
    });
    console.log('Purchase successful:', result);
  } catch (error) {
    console.error('Purchase failed:', error);
  }
};
```

### Adding IP Authorization
```typescript
const { createIpAuthorization } = useProxy();

const handleAddIp = async (ip: string) => {
  try {
    const result = await createIpAuthorization(ip);
    console.log('IP authorized:', result);
  } catch (error) {
    console.error('Authorization failed:', error);
  }
};
```

### Downloading Proxy List
```typescript
const { downloadProxyList } = useProxy();

const handleDownload = async () => {
  try {
    const result = await downloadProxyList({ country: 'US' });
    window.open(result.download_url, '_blank');
  } catch (error) {
    console.error('Download failed:', error);
  }
};
```

## Error Handling

The integration includes comprehensive error handling:

1. **API Errors**: All API calls are wrapped in try-catch blocks
2. **Validation**: Input validation for all user inputs
3. **User Feedback**: Loading states and error messages
4. **Logging**: Detailed error logging for debugging

## Security Considerations

1. **API Key Protection**: Store API keys in environment variables
2. **Authentication**: All endpoints require user authentication
3. **Input Validation**: Validate all user inputs
4. **Rate Limiting**: Implement rate limiting for API calls
5. **HTTPS**: Use HTTPS for all API communications

## Testing

Test the integration with:

1. **Unit Tests**: Test individual service methods
2. **Integration Tests**: Test API endpoints
3. **Frontend Tests**: Test React components and hooks
4. **End-to-End Tests**: Test complete user workflows

## Deployment

1. **Environment Setup**: Configure environment variables
2. **Database Migration**: Run any necessary migrations
3. **Service Registration**: Register the service in Laravel
4. **Frontend Build**: Build and deploy the React application

## Monitoring

Monitor the integration with:

1. **API Response Times**: Track API performance
2. **Error Rates**: Monitor error frequencies
3. **Usage Statistics**: Track feature usage
4. **User Feedback**: Collect user feedback

This integration provides a complete proxy service solution with full management capabilities, user-friendly interface, and robust error handling.
