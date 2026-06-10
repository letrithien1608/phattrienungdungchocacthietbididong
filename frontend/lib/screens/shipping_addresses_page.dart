import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ShippingAddressesPage extends StatelessWidget {
  const ShippingAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final addresses = [
      '3 Newbridge Court, Chino Hills, CA 91709, United States',
      '123 Main Street, New York, NY 10001, United States',
      '456 Elm Street, Los Angeles, CA 90001, United States'
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
        title: const Text('Shipping Addresses', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final addr = addresses[index];
          final isDefault = appState.defaultShippingAddress == addr;
          
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
                    Text('Address ${index + 1}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        appState.updateShippingAddress(addr);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default address updated'), backgroundColor: Colors.green));
                      },
                      child: Text('Set as default', style: TextStyle(fontSize: 14, color: isDefault ? Colors.grey : const Color(0xFFDB3022), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(addr.replaceAll(', ', '\n'), style: const TextStyle(fontSize: 14, height: 1.5)),
                if (isDefault) ...[
                  const SizedBox(height: 8),
                  const Text('✓ Default shipping address', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ]
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add new address functionality coming soon')));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
