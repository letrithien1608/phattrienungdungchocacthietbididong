import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final methods = [
      '**** **** **** 3947',
      '**** **** **** 1234',
      'paypal@example.com'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment Methods', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: methods.length,
        itemBuilder: (context, index) {
          final method = methods[index];
          final isDefault = appState.defaultPaymentMethod == method;
          final isCard = !method.contains('@');
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(isCard ? Icons.credit_card : Icons.account_balance_wallet, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(method, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        appState.updatePaymentMethod(method);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default payment method updated'), backgroundColor: Colors.green));
                      },
                      child: Text('Set as default', style: TextStyle(fontSize: 14, color: isDefault ? Colors.grey : const Color(0xFFDB3022), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                if (isDefault) ...[
                  const SizedBox(height: 12),
                  const Text('✓ Default payment method', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ]
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add new card functionality coming soon')));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
