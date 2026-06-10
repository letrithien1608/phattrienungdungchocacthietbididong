import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderNo;

  const OrderDetailsPage({super.key, required this.orderNo});

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
        title: const Text('Order Details', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order $orderNo', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('05-12-2019', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Tracking number: IW3475453455', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Delivered', style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('3 items', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildOrderItem('Pullover', 'Mango', 'Black', 'L', 51, 1, 'assets/images/detail_1.jpg'),
            const SizedBox(height: 16),
            _buildOrderItem('T-Shirt', 'T-Shirt SPAN', 'Gray', 'L', 30, 1, 'assets/images/detail_2.jpg'),
            const SizedBox(height: 16),
            _buildOrderItem('Sport Dress', 'Dorothy Perkins', 'Black', 'M', 43, 1, 'assets/images/detail_3.jpg'),
            const SizedBox(height: 32),
            const Text('Order information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Shipping Address:', '3 Newbridge Court, Chino Hills,\nCA 91709, United States'),
            const SizedBox(height: 16),
            _buildInfoRow('Payment method:', '**** **** **** 3947'),
            const SizedBox(height: 16),
            _buildInfoRow('Delivery method:', 'FedEx, 3 days, 15\$'),
            const SizedBox(height: 16),
            _buildInfoRow('Discount:', '10%, Personal promo code'),
            const SizedBox(height: 16),
            _buildInfoRow('Total Amount:', '133\$'),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text('Reorder', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Leave feedback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildOrderItem(String name, String brand, String color, String size, int price, int units, String imagePath) {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            child: imagePath.startsWith('http')
                ? Image.network(imagePath, width: 104, height: 104, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 104, height: 104, color: Colors.grey[300]))
                : Image.asset(imagePath, width: 104, height: 104, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 104, height: 104, color: Colors.grey[300])),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(brand, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(name, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('Color: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(color, style: const TextStyle(fontSize: 11, color: Colors.black)),
                      const SizedBox(width: 12),
                      const Text('Size: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(size, style: const TextStyle(fontSize: 11, color: Colors.black)),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('Units: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(units.toString(), style: const TextStyle(fontSize: 11, color: Colors.black)),
                        ],
                      ),
                      Text('\$$price', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
