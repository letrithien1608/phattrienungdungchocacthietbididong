import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'rating_reviews_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductService _productService = ProductService();
  List<Product> _relatedProducts = [];
  bool _isLoadingRelated = true;

  final List<String> _productImages = [
    'assets/images/detail_1.jpg',
    'assets/images/detail_2.jpg',
    'assets/images/detail_3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchProductReviews(widget.product.id);
    });
  }

  Future<void> _fetchRelatedProducts() async {
    try {
      final prods = await _productService.getNewProducts();
      if (mounted) {
        setState(() {
          _relatedProducts = prods;
          _isLoadingRelated = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRelated = false;
        });
      }
    }
  }

  Widget _buildProductCard(Product p, AppState appState) {
    bool isNetwork = p.image != null && p.image!.startsWith('http');
    String imgPath = p.image ?? 'assets/images/product_new_1.jpg';
    final _reviews = appState.getReviews(p.id);
    int totalReviews = _reviews.length;
    double averageRating = totalReviews > 0 ? _reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews : 0.0;

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: p),
          ),
        );
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: isNetwork 
                      ? Image.network(imgPath, width: 150, height: 184, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 150, height: 184, color: Colors.grey[300]))
                      : Image.asset(imgPath, width: 150, height: 184, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 150, height: 184, color: Colors.grey[300])),
                ),
                Positioned(
                  bottom: -15,
                  right: 0,
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      final isFav = appState.isFavorite(p);
                      return FloatingActionButton.small(
                        heroTag: 'fav_detail_related_${p.id}',
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
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < averageRating.round() ? Icons.star : Icons.star_border, 
                    color: const Color(0xFFFFBA49), 
                    size: 14,
                  );
                }),
                const SizedBox(width: 4),
                Text('($totalReviews)', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Mango Boy', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text(p.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text('\$${p.salePrice.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showSelectSizeBottomSheet(BuildContext context, bool isAddToCart) {
    String? selectedSize;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
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
                  const Text(
                    'Select size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: ['XS', 'S', 'M', 'L', 'XL'].map((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: isSelected ? const Color(0xFFDB3022) : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected ? const Color(0xFFDB3022) : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              size, 
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const ListTile(
                    title: Text('Size info', style: TextStyle(fontSize: 16)),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedSize == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a size first'), backgroundColor: Colors.red),
                          );
                          return;
                        }
                        Navigator.pop(context);
                        if (isAddToCart) {
                          try {
                            await Provider.of<AppState>(context, listen: false).addToCart(widget.product, selectedSize!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added to cart (Size: $selectedSize)'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                              );
                            }
                          }
                        } else {
                          try {
                            await Provider.of<AppState>(context, listen: false).toggleFavorite(widget.product, selectedSize!);
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
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        isAddToCart ? 'ADD TO CART' : 'ADD TO FAVORITES',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
        );
      },
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
    final appState = Provider.of<AppState>(context);
    final _reviews = appState.getReviews(widget.product.id);
    int totalReviews = _reviews.length;
    double averageRating = totalReviews > 0 ? _reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () async => Navigator.pop(context),
        ),
        title: Text(
          widget.product.productName,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () async {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Carousel
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Builder(builder: (context) {
                final mainImg = widget.product.image;
                if (mainImg == null || mainImg.isEmpty) {
                  return Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image_not_supported)));
                }
                
                List<String> images = [mainImg];
                if (mainImg.endsWith('_1.jpg') && !mainImg.startsWith('http')) {
                   String base = mainImg.substring(0, mainImg.length - 6);
                   images = [mainImg, '${base}_2.jpg', '${base}_3.jpg'];
                } else if (mainImg.endsWith('_1.png') && !mainImg.startsWith('http')) {
                   String base = mainImg.substring(0, mainImg.length - 6);
                   images = [mainImg, '${base}_2.png', '${base}_3.png'];
                }

                return PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final img = images[index];
                    if (img.startsWith('http')) {
                      return Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]));
                    }
                    return Image.asset(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]));
                  },
                );
              }),
            ),
            
            // Size & Color Selectors
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'Size',
                          isExpanded: true,
                          items: ['Size', 'S', 'M', 'L', 'XL'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'Black',
                          isExpanded: true,
                          items: ['Black', 'White', 'Red'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      final isFav = appState.isFavorite(widget.product);
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                          ],
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (isFav) {
                              try {
                                await appState.toggleFavorite(widget.product, '');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Removed from favorites'),
                                      backgroundColor: Colors.black,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                                  );
                                }
                              }
                            } else {
                              _showSelectSizeBottomSheet(context, false);
                            }
                          },
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? const Color(0xFFDB3022) : Colors.grey,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Product Title and Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('H&M', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(widget.product.productName, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RatingReviewsPage(product: widget.product)),
                            );
                          },
                          child: Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < averageRating.round() ? Icons.star : Icons.star_border, 
                                  color: const Color(0xFFFFBA49), 
                                  size: 14,
                                );
                              }),
                              const SizedBox(width: 4),
                              Text('($totalReviews)', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${widget.product.salePrice}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.product.shortDescription ?? 'No description available.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            
            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    _showSelectSizeBottomSheet(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDB3022),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'ADD TO CART',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            
            // Expandable Sections
            ListTile(
              title: const Text('Shipping info', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () async {},
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            ListTile(
              title: const Text('Support', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () async {},
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            ListTile(
              title: const Text('Rating and Reviews', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RatingReviewsPage(product: widget.product)),
                );
              },
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            
            // You can also like this
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('You can also like this', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${_relatedProducts.length} items', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            
            SizedBox(
              height: 280,
              child: _isLoadingRelated
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFDB3022)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _relatedProducts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: _buildProductCard(_relatedProducts[index], appState),
                      );
                    },
                  ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
