import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'shop_page.dart';
import 'product_detail_page.dart';
import 'favorites_page.dart';
import 'bag_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  bool _isMain1 = true;
  
  final ProductService _productService = ProductService();
  List<Product> _newProducts = [];
  List<Product> _saleProducts = [];
  bool _isLoading = true;
  
  final List<String> _bannerImages = [
    'assets/images/main_banner.jpg',
    'assets/images/banner_street.jpg',
    'assets/images/banner_new_collection.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= _bannerImages.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final newProds = await _productService.getNewProducts();
      final saleProds = await _productService.getSaleProducts();
      if (mounted) {
        setState(() {
          _newProducts = newProds;
          _saleProducts = saleProds;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildSlideshow({double? height, bool isExpanded = false}) {
    Widget content = PageView.builder(
      controller: _pageController,
      itemCount: _bannerImages.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _bannerImages[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: Center(child: Text(_bannerImages[index])),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fashion\nsale',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 160,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text('Check', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    
    if (isExpanded) {
      return content; // If expanded, don't wrap in SizedBox so it fills parent
    }
    return SizedBox(
      height: height ?? 450,
      width: double.infinity,
      child: content,
    );
  }

  Widget _buildStreetClothes({double? forceHeight, bool isExpanded = false}) {
    Widget content = Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/banner_street.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(child: Text('banner_street.jpg')),
          ),
        ),
        Container(
          color: Colors.black26,
        ),
        const Positioned(
          bottom: 20,
          left: 16,
          child: Text(
            'Street clothes',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    if (isExpanded) {
      return content;
    }
    return SizedBox(
      height: forceHeight ?? 250.0,
      width: double.infinity,
      child: content,
    );
  }

  Widget _buildSaleSection({bool isExpanded = false}) {
    Widget list = _isLoading 
      ? const Center(child: CircularProgressIndicator(color: Color(0xFFDB3022)))
      : _saleProducts.isEmpty 
        ? const Center(child: Text('No sale products found'))
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _saleProducts.length > 5 ? 5 : _saleProducts.length,
            itemBuilder: (context, index) {
              final p = _saleProducts[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: _buildProductCard(
                  p,
                  '-20%',
                  const Color(0xFFDB3022),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: p),
                      ),
                    );
                  },
                ),
              );
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sale',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Super summer sale",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _onItemTapped(1),
                child: const Text(
                  'View all',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        isExpanded ? Expanded(child: list) : SizedBox(height: 280, child: list),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildNewSection({bool isExpanded = false}) {
    Widget list = _isLoading 
      ? const Center(child: CircularProgressIndicator(color: Colors.black))
      : _newProducts.isEmpty 
        ? const Center(child: Text('No new products found'))
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _newProducts.length > 10 ? 10 : _newProducts.length,
            itemBuilder: (context, index) {
              final p = _newProducts[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: _buildProductCard(
                  p,
                  'NEW', 
                  Colors.black,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: p),
                      ),
                    );
                  }
                ),
              );
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'New',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "You've never seen it before!",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _onItemTapped(1),
                child: const Text(
                  'View all',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        isExpanded ? Expanded(child: list) : SizedBox(height: 280, child: list),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildNewCollectionSection({bool isExpanded = false}) {
    Widget topBanner = Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/banner_new_collection.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(child: Text('banner_new_collection.jpg')),
          ),
        ),
        Container(
          color: Colors.black26,
        ),
        const Positioned(
          bottom: 20,
          right: 16,
          child: Text(
            'New collection',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );

    Widget bottomRow = Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Text(
                      'Summer\nsale',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFDB3022),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/banner_black.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('banner_black.jpg')),
                      ),
                    ),
                    Container(
                      color: Colors.black26,
                    ),
                    const Positioned(
                      bottom: 16,
                      left: 16,
                      child: Text(
                        'Black',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/banner_mens_hoodies.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Text('banner_mens_hoodies.jpg')),
                ),
              ),
              Container(
                color: Colors.black26,
              ),
              const Positioned(
                top: 40,
                left: 16,
                child: Text(
                  "Men's\nhoodies",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isExpanded) {
      return Column(
        children: [
          Expanded(flex: 1, child: topBanner),
          Expanded(flex: 1, child: bottomRow),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(height: 300, width: double.infinity, child: topBanner),
        SizedBox(height: 300, width: double.infinity, child: bottomRow),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _fetchProducts,
      color: const Color(0xFFDB3022),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Slideshow
            _buildSlideshow(isExpanded: false, height: 350),
            
            // Sale + New
            _buildSaleSection(isExpanded: false),
            _buildNewSection(isExpanded: false),
            
            // New Collection
            _buildNewCollectionSection(isExpanded: false),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product p, String badgeText, Color badgeColor, {VoidCallback? onTap}) {
    String imagePath = p.image ?? 'assets/images/product_new_1.jpg';
    final isNetwork = imagePath.startsWith('http');
    
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isNetwork 
                      ? Image.network(
                          imagePath,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 150,
                            color: Colors.grey[300],
                            child: const Center(child: Icon(Icons.image_not_supported)),
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 150,
                            color: Colors.grey[300],
                            child: Center(child: Text(imagePath.split('/').last, textAlign: TextAlign.center)),
                          ),
                        ),
                  ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -15,
                  right: 0,
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      final isFav = appState.isFavorite(p);
                      return FloatingActionButton.small(
                        heroTag: 'fav_main_${p.id}', // Unique tag
                        onPressed: () async {
                          if (isFav) {
                            try { await appState.toggleFavorite(p, ''); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from favorites'),
                                backgroundColor: Colors.black,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else {
                            _showSelectSizeForFavorite(context, p, appState);
                          }
                        },
                        backgroundColor: Colors.white,
                        elevation: 2,
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? const Color(0xFFDB3022) : Colors.grey,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
            const SizedBox(height: 8),
            Consumer<AppState>(
              builder: (context, appState, child) {
                final reviews = appState.getReviews(p.id);
                int totalRating = 0;
                for (var r in reviews) totalRating += r.rating;
                double avgRating = reviews.isNotEmpty ? totalRating / reviews.length : 0.0;
                return Row(
                  children: [
                    ...List.generate(5, (index) {
                      if (index < avgRating.round()) {
                        return const Icon(Icons.star, color: Color(0xFFFFBA49), size: 14);
                      } else {
                        return const Icon(Icons.star_border, color: Colors.grey, size: 14);
                      }
                    }),
                    const SizedBox(width: 4),
                    Text('(${reviews.length})', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            const Text('Mango', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text(p.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            Row(
              children: [
                if (p.comparePrice != null) ...[
                  Text('\$${p.comparePrice!.toInt()}', style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  const SizedBox(width: 4),
                ],
                Text('\$${p.salePrice.toInt()}', style: TextStyle(fontSize: 14, color: p.comparePrice != null ? const Color(0xFFDB3022) : Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }



  void _showSelectSizeForFavorite(BuildContext context, Product product, AppState appState) {
    String? selectedSize = 'L';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.only(top: 16, bottom: 32, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['XS', 'S', 'M', 'L', 'XL'].map((s) {
                      bool isSelected = selectedSize == s;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedSize = s;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? const Color(0xFFDB3022) : Colors.white,
                            border: Border.all(color: isSelected ? const Color(0xFFDB3022) : Colors.grey),
                          ),
                          child: Center(
                            child: Text(s, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          await appState.toggleFavorite(product, selectedSize!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to favorites'), backgroundColor: Colors.green),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('ADD TO FAVORITES', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      const ShopPage(),
      const BagPage(),
      const FavoritesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFDB3022),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Bag'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
