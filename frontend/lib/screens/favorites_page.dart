import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/product.dart';
import 'filters_page.dart';
import 'product_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<String> _filters = ['Summer', 'T-Shirts', 'Shirts'];
  int _selectedFilter = 0;
  bool _isLoading = true;
  String _currentSort = 'Price: lowest to high';
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      await appState.fetchFavorites();
    } catch (e) {
      // Ignored here, state updated to empty in AppState
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSortByBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60, height: 6,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Sort by', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildSortOption('Price: lowest to high'),
                  _buildSortOption('Price: highest to low'),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildSortOption(String title) {
    bool isSelected = _currentSort == title;
    return InkWell(
      onTap: () {
        setState(() => _currentSort = title);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: isSelected ? const Color(0xFFDB3022) : Colors.transparent,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTags() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortBar() {
    return Container(
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.filter_list, size: 24),
              SizedBox(width: 8),
              Text('Filters', style: TextStyle(fontSize: 14)),
            ],
          ),
          InkWell(
            onTap: _showSortByBottomSheet,
            child: Row(
              children: [
                const Icon(Icons.swap_vert, size: 24),
                const SizedBox(width: 8),
                Text(_currentSort, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.view_module : Icons.view_list, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(Product p, AppState appState) {
    bool isNetwork = p.image != null && p.image!.startsWith('http');
    String imagePath = p.image ?? 'assets/images/product_new_1.jpg';
    
    final reviews = appState.getReviews(p.id);
    int totalRating = 0;
    for (var r in reviews) totalRating += r.rating;
    double avgRating = reviews.isNotEmpty ? totalRating / reviews.length : 0.0;

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: p)));
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 124,
            margin: const EdgeInsets.only(bottom: 24),
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
                  child: isNetwork
                      ? Image.network(imagePath, width: 104, height: 124, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 104, height: 124, color: Colors.grey[300]))
                      : Image.asset(imagePath, width: 104, height: 124, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 104, height: 124, color: Colors.grey[300])),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Mango', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            GestureDetector(
                              onTap: () async {
                                try { await appState.toggleFavorite(p, ''); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
                              },
                              child: const Icon(Icons.close, color: Colors.grey, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(p.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(
                              width: 85,
                              child: Row(
                                children: [
                                  const Text('Color: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  const Text('Black', style: TextStyle(fontSize: 11, color: Colors.black)),
                                ],
                              ),
                            ),
                            const Text('Size: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(p.favoriteSize ?? 'L', style: const TextStyle(fontSize: 11, color: Colors.black)),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 85,
                              child: Text('\$${p.salePrice.toInt()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            ...List.generate(5, (index) {
                              if (index < avgRating.round()) {
                                return const Icon(Icons.star, color: Color(0xFFFFBA49), size: 14);
                              } else {
                                return const Icon(Icons.star_border, color: Colors.grey, size: 14);
                              }
                            }),
                            const SizedBox(width: 2),
                            Text('(${reviews.length})', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 0,
            child: SizedBox(
              width: 36,
              height: 36,
              child: FloatingActionButton(
                heroTag: 'fav_tab_${p.id}',
                onPressed: () async {
                  try { await appState.addToCart(p, 'L'); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart'), backgroundColor: Colors.green, duration: Duration(seconds: 1)),
                  );
                },
                backgroundColor: const Color(0xFFDB3022),
                elevation: 4,
                child: const Icon(Icons.shopping_bag, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridFavoriteItem(Product p, AppState appState) {
    bool isNetwork = p.image != null && p.image!.startsWith('http');
    String imgPath = p.image ?? 'assets/images/product_new_1.jpg';

    final reviews = appState.getReviews(p.id);
    int totalRating = 0;
    for (var r in reviews) totalRating += r.rating;
    double avgRating = reviews.isNotEmpty ? totalRating / reviews.length : 0.0;

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: p)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isNetwork 
                    ? Image.network(imgPath, width: double.infinity, height: 170, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 170, color: Colors.grey[300]))
                    : Image.asset(imgPath, width: double.infinity, height: 170, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 170, color: Colors.grey[300])),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () async {
                    try { await appState.toggleFavorite(p, ''); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
                  },
                  child: const Icon(Icons.close, color: Colors.grey, size: 18),
                ),
              ),
              Positioned(
                bottom: -18,
                right: 0,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: FloatingActionButton(
                    heroTag: 'fav_grid_${p.id}',
                    onPressed: () async {
                      try { await appState.addToCart(p, 'L'); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart'), backgroundColor: Colors.green, duration: Duration(seconds: 1)),
                      );
                    },
                    backgroundColor: const Color(0xFFDB3022),
                    elevation: 4,
                    child: const Icon(Icons.shopping_bag, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
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
          ),
          const SizedBox(height: 4),
          const Text('Mango', style: TextStyle(fontSize: 11, color: Colors.grey)),
          Text(p.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('\$${p.salePrice.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          List<Product> displayedList = List.from(appState.favorites);
          
          String selectedTag = _filters[_selectedFilter];
          if (selectedTag == 'T-Shirts') {
            displayedList = displayedList.where((p) => p.productName.toLowerCase().contains('t-shirt') || (p.productType?.toLowerCase() == 't-shirts')).toList();
          } else if (selectedTag == 'Shirts') {
            displayedList = displayedList.where((p) => p.productName.toLowerCase().contains('shirt') && !p.productName.toLowerCase().contains('t-shirt')).toList();
          }
          
          if (_currentSort == 'Price: lowest to high') {
            displayedList.sort((a, b) => a.salePrice.compareTo(b.salePrice));
          } else if (_currentSort == 'Price: highest to low') {
            displayedList.sort((a, b) => b.salePrice.compareTo(a.salePrice));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 50),
                child: const Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(color: Colors.white, child: _buildFilterTags()),
              _buildSortBar(),
              Expanded(
                child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFDB3022)))
                    : RefreshIndicator(
                        onRefresh: _loadFavorites,
                        color: const Color(0xFFDB3022),
                        child: displayedList.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                  const Center(
                                    child: Text('No favorites yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                                  ),
                                ],
                              )
                            : _isGrid
                                ? GridView.builder(
                                    padding: const EdgeInsets.all(16),
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.55,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: displayedList.length,
                                    itemBuilder: (context, index) {
                                      return _buildGridFavoriteItem(displayedList[index], appState);
                                    },
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: displayedList.length,
                                    itemBuilder: (context, index) {
                                      return _buildFavoriteItem(displayedList[index], appState);
                                    },
                                  ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

