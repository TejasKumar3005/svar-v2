import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';


class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Product IDs - you should define these based on your app store configuration
  static const String feePayment = 'fee_monthly';
  // static const String feePayment75 = 'fee_payment_75';
  static const List<String> _productIds = [feePayment];

  // Available products
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // Purchase state
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Callbacks
  Function(String productId, bool success)? onPurchaseComplete;
  Function(String error)? onPurchaseError;
  Function(bool isLoading)? onLoadingStateChanged;

  Future<void> initialize() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();

      if (_isAvailable) {
        // Initialize platform-specific configurations
        if (Platform.isIOS) {
          final InAppPurchaseStoreKitPlatformAddition iosAddition =
              _inAppPurchase
                  .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
          await iosAddition.setDelegate(ExamplePaymentQueueDelegate());
        }

        // Listen for purchase updates
        _subscription = _inAppPurchase.purchaseStream.listen(
          _handlePurchaseUpdates,
          onDone: () => _subscription.cancel(),
          onError: (error) => _handleError('Purchase stream error: $error'),
        );

        // Load products
        await _loadProducts();
      } else {
        _handleError('In-app purchases not available on this device');
      }
    } catch (e) {
      _handleError('Failed to initialize in-app purchases: $e');
    }
  }

  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_productIds.toSet());

      if (response.notFoundIDs.isNotEmpty) {
        print('Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;

      if (_products.isEmpty) {
        _handleError('No products found. Please check your product IDs.');
      }
    } catch (e) {
      _handleError('Failed to load products: $e');
    }
  }

  Future<void> buyProduct(String productId, double amount) async {
    if (!_isAvailable) {
      _handleError('In-app purchases not available');
      return;
    }

    final ProductDetails? productDetails =
        _products.where((product) => product.id == productId).firstOrNull;

    if (productDetails == null) {
      _handleError('Product not found: $productId');
      return;
    }

    try {
      _purchasePending = true;
      onLoadingStateChanged?.call(true);

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null, // You can set user ID here if needed
      );

      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true, // Automatically consume the purchase
      );
    } catch (e) {
      _purchasePending = false;
      onLoadingStateChanged?.call(false);
      _handleError('Failed to initiate purchase: $e');
    }
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _showPendingUI();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _handleSuccessfulPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _handlePurchaseError(purchaseDetails);
          break;
        default:
          break;
      }

      // Always complete the purchase on Android
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _showPendingUI() {
    _purchasePending = true;
    onLoadingStateChanged?.call(true);
  }

  Future<void> _handleSuccessfulPurchase(
      PurchaseDetails purchaseDetails) async {
    try {
      _purchasePending = false;
      onLoadingStateChanged?.call(false);

      // Here you would typically validate the purchase with your backend
      // and update the user's account

      onPurchaseComplete?.call(purchaseDetails.productID, true);

      print('Purchase successful: ${purchaseDetails.productID}');
    } catch (e) {
      _handleError('Failed to process successful purchase: $e');
    }
  }

  void _handlePurchaseError(PurchaseDetails purchaseDetails) {
    _purchasePending = false;
    onLoadingStateChanged?.call(false);

    final String errorMessage =
        purchaseDetails.error?.message ?? 'Unknown purchase error';
    _handleError('Purchase failed: $errorMessage');

    onPurchaseComplete?.call(purchaseDetails.productID, false);
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      _handleError('In-app purchases not available');
      return;
    }

    try {
      onLoadingStateChanged?.call(true);
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _handleError('Failed to restore purchases: $e');
    } finally {
      onLoadingStateChanged?.call(false);
    }
  }

  void _handleError(String error) {
    _errorMessage = error;
    onPurchaseError?.call(error);
    print('IAP Error: $error');
  }

  void dispose() {
    _subscription.cancel();
  }

  // Helper method to get product by amount
  ProductDetails? getProductByAmount(double amount) {
    final String productId = "fee_monthly";
    return _products.where((product) => product.id == productId).firstOrNull;
  }
}

// iOS-specific payment queue delegate
class ExamplePaymentQueueDelegate extends SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
