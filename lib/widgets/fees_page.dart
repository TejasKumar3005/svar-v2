import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'package:svar_new/core/services/in_app_purchase_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({Key? key}) : super(key: key);

  @override
  _FeesPageState createState() => _FeesPageState();
  static Widget builder(BuildContext context) {
    return const FeesPage();
  }
}

class _FeesPageState extends State<FeesPage> {
  bool _historyExpanded = false;
  bool _autoPayEnabled = false;
  bool _isLoading = false;
  String? _errorMessage;

  int _currentIndex = 3; // Default to Today tab

  final InAppPurchaseService _iapService = InAppPurchaseService();

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchases();
  }

  @override
  void dispose() {
    _iapService.dispose();
    super.dispose();
  }

  Future<void> _initializeInAppPurchases() async {
    // Set up callbacks
    _iapService.onPurchaseComplete = _onPurchaseComplete;
    _iapService.onPurchaseError = _onPurchaseError;
    _iapService.onLoadingStateChanged = _onLoadingStateChanged;

    // Initialize the service
    await _iapService.initialize();
  }

  void _onPurchaseComplete(String productId, bool success) {
    if (success) {
      setState(() {
        _errorMessage = null;
      });

      // Show success dialog
      _showPurchaseSuccessDialog();

      // Update the fee as paid (in a real app, this would be handled by your backend)
      _markFeeAsPaid(productId);
    }
  }

  void _onPurchaseError(String error) {
    setState(() {
      _errorMessage = error;
    });

    // Show error dialog
    _showErrorDialog(error);
  }

  void _onLoadingStateChanged(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _markFeeAsPaid(String productId) {
    // In a real app, you would update this through your backend
    // For now, we'll just update the local state
    setState(() {
      for (var fee in currentFees) {
        double amount = fee['amount'];
        String expectedProductId = InAppPurchaseService.feePayment;

        if (expectedProductId == productId) {
          fee['isPaid'] = true;
          break;
        }
      }
    });
  }

  void _showPurchaseSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Payment Successful'),
            ],
          ),
          content: const Text('Your payment has been processed successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Payment Error'),
            ],
          ),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _purchaseFee(double amount) async {
    if (!_iapService.isAvailable) {
      _showErrorDialog('In-app purchases are not available on this device.');
      return;
    }

    final String productId = InAppPurchaseService.feePayment;

    await _iapService.buyProduct(productId, amount);
  }

  // This function handles index changes from the bottom navigation bar
  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Note: The navigation logic is handled inside the CustomBottomNavigationBar
  }

  // Sample data for current fees
  final List<Map<String, dynamic>> currentFees = [
    {
      'id': 1,
      'amount': 95.00,
      'dueDate': DateTime(2025, 3, 18),
      'isPaid': false
    },
    {
      'id': 2,
      'amount': 75.00,
      'dueDate': DateTime(2025, 3, 25),
      'isPaid': false
    },
  ];

  // Sample data for previous fees
  final List<Map<String, dynamic>> previousFees = [
    {
      'id': 101,
      'amount': 95.00,
      'dueDate': DateTime(2025, 3, 4),
      'paidDate': DateTime(2025, 3, 3),
      'onTime': true
    },
    {
      'id': 102,
      'amount': 75.00,
      'dueDate': DateTime(2025, 2, 25),
      'paidDate': DateTime(2025, 2, 25),
      'onTime': true
    },
    {
      'id': 103,
      'amount': 95.00,
      'dueDate': DateTime(2025, 2, 18),
      'paidDate': DateTime(2025, 2, 20),
      'onTime': false
    },
    {
      'id': 104,
      'amount': 75.00,
      'dueDate': DateTime(2025, 2, 11),
      'paidDate': DateTime(2025, 2, 11),
      'onTime': true
    },
    {
      'id': 105,
      'amount': 95.00,
      'dueDate': DateTime(2025, 2, 4),
      'paidDate': DateTime(2025, 2, 4),
      'onTime': true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Fees Section
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                'Current Fees Due',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5F6368),
                ),
              ),
            ),
            ...currentFees.map((fee) => _buildCurrentFeeCard(fee)),

            const SizedBox(height: 20),

            // Payment History Section
            _buildPaymentHistorySection(),

            const SizedBox(height: 20),

            // Payment Methods Section
            _buildPaymentMethodsSection(),

            const SizedBox(height: 20),

            // Auto-Pay Section
            _buildAutoPaySection(),

            // Space for bottom navigation
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentFeeCard(Map<String, dynamic> fee) {
    final dateFormat = DateFormat('MMMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${fee['amount'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.notifications_active,
                          size: 16, color: Color(0xFFEF9A37)),
                      SizedBox(width: 4),
                      Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF9A37),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: Color(0xFF9AA0A6)),
                const SizedBox(width: 8),
                Text(
                  'Due: ${dateFormat.format(fee['dueDate'])}',
                  style: const TextStyle(
                    color: Color(0xFF5F6368),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: fee['isPaid'] || _isLoading
                    ? null
                    : () => _purchaseFee(fee['amount']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: fee['isPaid'] ? Colors.grey : Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            fee['isPaid'] ? Icons.check : Icons.attach_money,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            fee['isPaid'] ? 'Paid' : 'Pay Now',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistorySection() {
    final dateFormat = DateFormat('MMMM d, yyyy');

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _historyExpanded = !_historyExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    _historyExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF9AA0A6),
                  ),
                ],
              ),
            ),
          ),
          if (_historyExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                children: previousFees.map((fee) {
                  return Column(
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${fee['amount'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: fee['onTime']
                                        ? const Color(0xFFE6F4EA)
                                        : const Color(0xFFFCE8E6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        fee['onTime']
                                            ? Icons.check_circle
                                            : Icons.access_time,
                                        size: 12,
                                        color: fee['onTime']
                                            ? const Color(0xFF34A853)
                                            : const Color(0xFFEA4335),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        fee['onTime'] ? 'On time' : 'Late',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: fee['onTime']
                                              ? const Color(0xFF34A853)
                                              : const Color(0xFFEA4335),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Due: ${dateFormat.format(fee['dueDate'])}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF5F6368),
                                  ),
                                ),
                                Text(
                                  'Paid: ${dateFormat.format(fee['paidDate'])}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF5F6368),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F0FE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          color: Color(0xFF4285F4),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Visa •••• 4242',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Expires 08/26',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5F6368),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3CB371),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Add Payment Method',
                    style: TextStyle(
                      color: Color(0xFF5F6368),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed:
                  _isLoading ? null : () => _iapService.restorePurchases(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.restore, color: Color(0xFF5F6368)),
                      SizedBox(width: 8),
                      Text(
                        'Restore Purchases',
                        style: TextStyle(
                          color: Color(0xFF5F6368),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoPaySection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Auto-Pay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Automatically pay fees when due',
                  style: TextStyle(
                    color: Color(0xFF5F6368),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Switch(
              value: _autoPayEnabled,
              onChanged: (value) {
                setState(() {
                  _autoPayEnabled = value;
                });
              },
              activeColor: const Color(0xFF3CB371),
            ),
          ],
        ),
      ),
    );
  }
}
