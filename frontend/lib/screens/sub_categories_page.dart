import 'package:flutter/material.dart';
import '../models/category.dart';
import 'catalog_page.dart';

class SubCategoriesPage extends StatelessWidget {
  final Category parentCategory;

  const SubCategoriesPage({super.key, required this.parentCategory});

  @override
  Widget build(BuildContext context) {
    // Danh sách giả lập sub-categories dựa theo thiết kế Categories 2.png
    // Thực tế có thể fetch từ API dựa vào parentId: parentCategory.id
    final List<String> subCategories = [
      'Tops',
      'Shirts & Blouses',
      'Cardigans & Sweaters',
      'Knitwear',
      'Blazers',
      'Outerwear',
      'Pants',
      'Jeans',
      'Shorts',
      'Skirts',
      'Dresses',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
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
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Nút VIEW ALL ITEMS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatalogPage(
                        categoryTitle: "All ${parentCategory.categoryName}",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB3022),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'VIEW ALL ITEMS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Dòng chữ Choose category
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Choose category',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Danh sách các mục con
          Expanded(
            child: ListView.separated(
              itemCount: subCategories.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CatalogPage(
                          categoryTitle: "${parentCategory.categoryName}'s ${subCategories[index].toLowerCase()}",
                          subCategoryName: subCategories[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: Text(
                      subCategories[index],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
