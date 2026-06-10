import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import 'sub_categories_page.dart';
import '../widgets/product_search_delegate.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
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
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCategoryCard(String title, String imagePath, {bool isLast = false}) {
    bool isNetwork = imagePath.startsWith('http');
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 5 : 16),
      height: 115,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: isNetwork 
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image_not_supported)),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Center(child: Text(imagePath.split('/').last, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    final List<Map<String, String>> staticCategories = [
      {'title': 'New', 'image': 'assets/images/banner_new_collection.jpg'},
      {'title': 'Clothes', 'image': 'assets/images/banner_street.jpg'},
      {'title': 'Shoes', 'image': 'assets/images/prod_sport_shoes.jpg'},
      {'title': 'Accesories', 'image': 'assets/images/category_accessories.jpg'},
    ];

    Category? parentCategory;
    if (_categories.isNotEmpty && _categories.length > tabIndex) {
      parentCategory = _categories[tabIndex];
    } else {
      parentCategory = Category(id: '0', categoryName: 'Unknown');
    }

    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: double.infinity,
          height: 110,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFDB3022),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'SUMMER SALES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Up to 50% off',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Color(0xFFDB3022)),
          ))
        else
          ...staticCategories.asMap().entries.map((entry) {
            int index = entry.key;
            var cat = entry.value;
            String img = cat['image']!;
            bool isLast = index == staticCategories.length - 1;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCategoriesPage(parentCategory: parentCategory!),
                  ),
                );
              },
              child: _buildCategoryCard(cat['title']!, img, isLast: isLast),
            );
          }).toList(),
      ],
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
          onPressed: () {
            // Optional: Handle back behavior if needed
          },
        ),
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFDB3022),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          tabs: const [
            Tab(text: 'Women'),
            Tab(text: 'Men'),
            Tab(text: 'Kids'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(0), // Women
          _buildTabContent(1), // Men
          _buildTabContent(2), // Kids
        ],
      ),
    );
  }
}
