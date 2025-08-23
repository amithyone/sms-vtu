<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ApiController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\SmsController;
use App\Http\Controllers\VtuController;
use App\Http\Controllers\ProxyController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public routes
Route::get('/test', [ApiController::class, 'test']);

// Authentication routes
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
});

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // User profile routes
    Route::prefix('user')->group(function () {
        Route::get('/profile', [AuthController::class, 'profile']);
        Route::put('/profile', [AuthController::class, 'updateProfile']);
        Route::post('/change-password', [AuthController::class, 'changePassword']);
        Route::get('/transactions', [AuthController::class, 'transactions']);
    });

    // Services endpoints
    Route::prefix('services')->group(function () {
        Route::get('/', [ApiController::class, 'getServices']);
        Route::post('/', [ApiController::class, 'createService']);
        Route::put('/{id}', [ApiController::class, 'updateService']);
        Route::delete('/{id}', [ApiController::class, 'deleteService']);
    });
    
    // SMS Service routes
    Route::prefix('sms')->group(function () {
        Route::get('/countries', [SmsController::class, 'getCountries']);
        Route::get('/services', [SmsController::class, 'getServices']);
        Route::get('/providers', [SmsController::class, 'getProviders']);
        Route::post('/order', [SmsController::class, 'createOrder']);
        Route::get('/code', [SmsController::class, 'getSmsCode']);
        Route::post('/cancel', [SmsController::class, 'cancelOrder']);
        Route::get('/orders', [SmsController::class, 'getOrders']);
        Route::get('/stats', [SmsController::class, 'getStats']);
    });
    
    // VTU Service routes (iRecharge)
    Route::prefix('vtu')->group(function () {
        Route::get('/airtime/networks', [VtuController::class, 'getAirtimeNetworks']);
        Route::get('/data/networks', [VtuController::class, 'getDataNetworks']);
        Route::get('/data/bundles', [VtuController::class, 'getDataBundles']);
        Route::post('/airtime/purchase', [VtuController::class, 'purchaseAirtime']);
        Route::post('/data/purchase', [VtuController::class, 'purchaseDataBundle']);
        Route::get('/transaction/status', [VtuController::class, 'getTransactionStatus']);
        Route::get('/provider/balance', [VtuController::class, 'getProviderBalance']);
        Route::post('/validate/phone', [VtuController::class, 'validatePhoneNumber']);
    });
    
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
    
    // Logout
    Route::post('/auth/logout', [AuthController::class, 'logout']);
});
