import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'orders_page.dart';
import 'settings_page.dart';
import 'shipping_addresses_page.dart';
import 'payment_methods_page.dart';
import 'promocodes_page.dart';
import 'my_reviews_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My profile',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appState.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(appState.userEmail, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildProfileMenuItem('My orders', 'Already have ${appState.orders.length} orders', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
                }),
                _buildProfileMenuItem('Shipping addresses', '3 addresses', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddressesPage()));
                }),
                _buildProfileMenuItem('Payment methods', 'Visa  **34', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsPage()));
                }),
                _buildProfileMenuItem('Promocodes', 'You have special promocodes', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PromocodesPage()));
                }),
                _buildProfileMenuItem('My reviews', 'Reviews for 4 items', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReviewsPage()));
                }),
                _buildProfileMenuItem('Settings', 'Notifications, password', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                }),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      appState.logout();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text('LOGOUT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileMenuItem(String title, String subtitle, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
