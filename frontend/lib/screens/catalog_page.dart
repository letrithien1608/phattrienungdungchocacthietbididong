import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'product_detail_page.dart';
import '../widgets/product_search_delegate.dart';
import 'filters_page.dart';

class CatalogPage extends StatefulWidget {
  final String categoryTitle;
  final String? subCategoryName;

  const CatalogPage({super.key, required this.categoryTitle, this.subCategoryName});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;
  bool _isGrid = false; // Toggle between list and grid
  String _currentSort = 'Price: lowest to high';

  final List<String> _subFilters = [
    'T-shirts',
    'Crop tops',
    'Sleeveless',
    'Shirts'
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _productService.getAllProducts();
      if (mounted) {
        setState(() {
          if (widget.subCategoryName != null) {
            _products = products.where((p) => 
              p.productType != null && p.productType!.toLowerCase() == widget.subCategoryName!.toLowerCase()
            ).toList();
          } else {
            _products = products;
          }
          _sortProducts();
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

  void _sortProducts() {
    if (_currentSort == 'Price: lowest to high') {
      _products.sort((a, b) => a.salePrice.compareTo(b.salePrice));
    } else if (_currentSort == 'Price: highest to low') {
      _products.sort((a, b) => b.salePrice.compareTo(a.salePrice));
    } else if (_currentSort == 'Newest') {
      // Assuming IDs are numeric or timestamps, fallback to string compare
      _products.sort((a, b) {
        final idA = int.tryParse(a.id) ?? 0;
        final idB = int.tryParse(b.id) ?? 0;
        if (idA != 0 && idB != 0) return idB.compareTo(idA);
        return b.id.compareTo(a.id);
      });
    } else if (_currentSort == 'Popular') {
      _products.sort((a, b) => (b.comparePrice ?? 0.0).compareTo(a.comparePrice ?? 0.0));
    } else if (_currentSort == 'Customer review') {
      _products.sort((a, b) => a.productName.compareTo(b.productName));
    }
  }

  Widget _buildFilterTags() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _subFilters.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                _subFilters[index],
                style: const TextStyle(color: Colors.white, fontSize: 14),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FiltersPage()));
            },
            child: Row(
              children: const [
                Icon(Icons.filter_list, size: 24),
                SizedBox(width: 8),
                Text('Filters', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              _showSortByBottomSheet();
            },
            child: Row(
              children: [
                const Icon(Icons.swap_vert, size: 24),
                const SizedBox(width: 8),
                Text(_currentSort, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.view_module),
            onPressed: () async {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListProductCard(Product p) {
    bool isNetwork = p.image != null && p.image!.startsWith('http');
    String imgPath = p.image ?? 'assets/images/product_new_1.jpg';
    
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: p),
          ),
        );
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: isNetwork 
                  ? Image.network(imgPath, width: 100, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 100, color: Colors.grey[300]))
                  : Image.asset(imgPath, width: 100, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 100, color: Colors.grey[300])),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.productName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text('Mango', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                    const Spacer(),
                    Text(
                      '\$${p.salePrice.toInt()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Consumer<AppState>(
                  builder: (context, appState, child) {
                    final isFav = appState.isFavorite(p);
                    return GestureDetector(
                      onTap: () async {
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
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? const Color(0xFFDB3022) : Colors.grey,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridProductCard(Product p) {
    bool isNetwork = p.image != null && p.image!.startsWith('http');
    String imgPath = p.image ?? 'assets/images/product_new_1.jpg';

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: p),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isNetwork 
                    ? Image.network(imgPath, width: double.infinity, height: 184, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 184, color: Colors.grey[300]))
                    : Image.asset(imgPath, width: double.infinity, height: 184, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 184, color: Colors.grey[300])),
              ),
              Positioned(
                bottom: -15,
                right: 0,
                child: Consumer<AppState>(
                  builder: (context, appState, child) {
                    final isFav = appState.isFavorite(p);
                    return FloatingActionButton.small(
                      heroTag: 'fav_grid_${p.id}',
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
          ),
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
          Text('\$${p.salePrice.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
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
                  const Text('Sort by', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildSortOption('Popular'),
                  _buildSortOption('Newest'),
                  _buildSortOption('Customer review'),
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
      onTap: () async {
        setState(() {
          _currentSort = title;
          _sortProducts();
        });
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () async => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () async {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              widget.categoryTitle,
              style: const TextStyle(
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
                : _products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : _isGrid
                        ? GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              return _buildGridProductCard(_products[index]);
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              return _buildListProductCard(_products[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
