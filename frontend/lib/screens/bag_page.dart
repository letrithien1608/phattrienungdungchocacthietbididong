import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'checkout_page.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  final TextEditingController _promoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    // Set the controller text if a promo is applied
    if (appState.appliedPromoCode.isNotEmpty && _promoController.text != appState.appliedPromoCode) {
      _promoController.text = appState.appliedPromoCode;
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () async {},
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
                  'My Bag',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 24),
                if (appState.cart.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text('Your bag is empty', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ),
                  )
                else
                  ...appState.cart.map((cartItem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildBagItem(cartItem, appState),
                    );
                  }).toList(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showPromoBottomSheet(appState),
                        child: TextField(
                          controller: _promoController,
                          readOnly: true,
                          onTap: () => _showPromoBottomSheet(appState),
                          decoration: const InputDecoration(
                            hintText: 'Enter your promo code',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showPromoBottomSheet(appState),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                        child: const Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total amount:', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('\$${appState.cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: appState.cart.isEmpty ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB3022),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('CHECK OUT', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBagItem(CartItem cartItem, AppState appState) {
    String imagePath = cartItem.product.image ?? 'assets/images/product_new_1.jpg';
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            child: imagePath.startsWith('http')
                ? Image.network(imagePath, width: 104, height: 130, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 104, height: 130, color: Colors.grey[300]))
                : Image.asset(imagePath, width: 104, height: 130, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 104, height: 130, color: Colors.grey[300])),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mango', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(cartItem.product.productName, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Color: ', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          Text('Black', style: const TextStyle(fontSize: 11, color: Colors.black)),
                          const SizedBox(width: 12),
                          Text('Size: ', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(cartItem.size, style: const TextStyle(fontSize: 11, color: Colors.black)),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              try {
                                await appState.decreaseQuantity(cartItem);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                                }
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                                ],
                              ),
                              child: const Icon(Icons.remove, color: Colors.grey, size: 20),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(cartItem.quantity.toString(), style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () async {
                              try {
                                await appState.increaseQuantity(cartItem);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                                }
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                ],
                              ),
                              child: const Icon(Icons.add, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          _showItemOptionsBottomSheet(cartItem, appState);
                        },
                        child: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text('\$${cartItem.product.salePrice.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showItemOptionsBottomSheet(CartItem cartItem, AppState appState) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
                ListTile(
                  title: const Center(child: Text('Add to favorites', style: TextStyle(fontSize: 18))),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await appState.toggleFavorite(cartItem.product, cartItem.size);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to favorites'), backgroundColor: Colors.green),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Center(child: Text('Delete from the list', style: TextStyle(fontSize: 18, color: Colors.red))),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await appState.removeFromCart(cartItem);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showPromoBottomSheet(AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your promo code',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(Icons.arrow_forward, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Your Promo Codes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildPromoCard(appState, 0.10, '10%', 'Personal offer', 'mypromocode2020', '6 days remaining'),
                    const SizedBox(height: 16),
                    _buildPromoCard(appState, 0.15, '15%', 'Summer Sale', 'summer2020', '23 days remaining'),
                    const SizedBox(height: 16),
                    _buildPromoCard(appState, 0.22, '22%', 'Personal offer', 'mypromocode2022', '6 days remaining'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoCard(AppState appState, double percent, String discount, String title, String code, String remaining) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: title == 'Summer Sale' ? Colors.black : const Color(0xFFDB3022),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                '$discount\noff',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
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
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(remaining, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      appState.applyPromoCode(code, percent);
                      _promoController.text = code;
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB3022),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
