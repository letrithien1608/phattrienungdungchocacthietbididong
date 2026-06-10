import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  RangeValues _priceRange = const RangeValues(78, 143);
  final List<Color> _colors = [
    Colors.black,
    const Color(0xFFF6F6F6),
    const Color(0xFFB82222),
    const Color(0xFFBEA9A9),
    const Color(0xFFE2BB8D),
    const Color(0xFF151867),
  ];
  int _selectedColor = 2;

  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  int _selectedSize = 2;

  final List<String> _categories = ['All', 'Women', 'Men', 'Boys', 'Girls'];
  int _selectedCategory = 0;

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
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Price range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${_priceRange.start.toInt()}'),
                Text('\$${_priceRange.end.toInt()}'),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 200,
              activeColor: const Color(0xFFDB3022),
              inactiveColor: Colors.grey.shade300,
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            const SizedBox(height: 24),
            
            const Text('Colors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_colors.length, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = index),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _colors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == index ? const Color(0xFFDB3022) : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        if (_selectedColor != index)
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            const Text('Sizes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(_sizes.length, (index) {
                bool isSelected = _selectedSize == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSize = index),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDB3022) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFDB3022) : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _sizes[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            const Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(_categories.length, (index) {
                bool isSelected = _selectedCategory == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDB3022) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFDB3022) : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Brand', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text('adidas Originals, Jack & Jones, s.Oliver', style: TextStyle(fontSize: 11, color: Colors.grey)),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text('Discard', style: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFDB3022),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Apply', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
