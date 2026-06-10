import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () async => Navigator.pop(context),
        ),
        title: const Text('Checkout', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shipping address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jane Doe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () async {
                          _showShippingAddressesBottomSheet(context, appState);
                        },
                        child: const Text('Change', style: TextStyle(fontSize: 14, color: Color(0xFFDB3022), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(appState.defaultShippingAddress.replaceAll(', ', '\n'), style: const TextStyle(fontSize: 14, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () async {
                    _showPaymentMethodsBottomSheet(context, appState);
                  },
                  child: const Text('Change', style: TextStyle(fontSize: 14, color: Color(0xFFDB3022), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 15, height: 15, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                        Container(width: 15, height: 15, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(appState.defaultPaymentMethod, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            
            const Text('Delivery method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDeliveryMethod('assets/images/fedex.png', '2-3 days'),
                _buildDeliveryMethod('assets/images/usps.png', '2-3 days'),
                _buildDeliveryMethod('assets/images/dhl.png', '2-3 days'),
              ],
            ),
            const SizedBox(height: 32),
            
            Consumer<AppState>(
              builder: (context, appState, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order:', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text('\$${appState.cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Delivery:', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text('\$15.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Summary:', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text('\$${(appState.cartTotal + 15).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  Provider.of<AppState>(context, listen: false).checkout();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Your order will be delivered soon. Thank you for choosing our app!'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context); // close dialog
                            Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false); // back to main
                          },
                          child: const Text('Continue shopping'),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB3022),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('SUBMIT ORDER', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMethod(String imagePath, String time) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Center(
            child: Icon(Icons.local_shipping, color: Colors.grey.shade400, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  void _showShippingAddressesBottomSheet(BuildContext context, AppState appState) {
    final addresses = [
      '3 Newbridge Court, Chino Hills, CA 91709, United States',
      '123 Main Street, New York, NY 10001, United States',
      '456 Elm Street, Los Angeles, CA 90001, United States'
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(34))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 60, height: 6, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 16),
              const Text('Shipping Addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...addresses.map((addr) => ListTile(
                title: Text(addr),
                trailing: appState.defaultShippingAddress == addr ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () async {
                  appState.updateShippingAddress(addr);
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 30),
            ],
          ),
        );
      }
    );
  }

  void _showPaymentMethodsBottomSheet(BuildContext context, AppState appState) {
    final methods = [
      '**** **** **** 3947',
      '**** **** **** 1234',
      'paypal@example.com'
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(34))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 60, height: 6, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 16),
              const Text('Payment Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...methods.map((method) => ListTile(
                leading: Icon(method.contains('@') ? Icons.account_balance_wallet : Icons.credit_card),
                title: Text(method),
                trailing: appState.defaultPaymentMethod == method ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () async {
                  appState.updatePaymentMethod(method);
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 30),
            ],
          ),
        );
      }
    );
  }
}
