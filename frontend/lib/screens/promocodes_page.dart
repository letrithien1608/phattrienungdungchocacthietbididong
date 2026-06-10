import 'package:flutter/material.dart';

class PromocodesPage extends StatelessWidget {
  const PromocodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Promocodes', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPromoCard('Personal offer', '10% off', 'mypromocode2024', 5),
          const SizedBox(height: 16),
          _buildPromoCard('Summer Sale', '15% off', 'summer2024', 23),
          const SizedBox(height: 16),
          _buildPromoCard('Welcome offer', '20% off', 'welcome2024', 3),
        ],
      ),
    );
  }

  Widget _buildPromoCard(String title, String discount, String code, int daysLeft) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFDB3022),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  discount.split(' ')[0],
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  discount.split(' ').skip(1).join(' '),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(code, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$daysLeft days remaining', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDB3022),
                    minimumSize: const Size(80, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
