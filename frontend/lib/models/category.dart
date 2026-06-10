class Category {
  final String id;
  final String? parentId;
  final String categoryName;
  final String? categoryDescription;
  final String? icon;
  final String? image;
  final String? placeholder;
  final bool? active;

  Category({
    required this.id,
    this.parentId,
    required this.categoryName,
    this.categoryDescription,
    this.icon,
    this.image,
    this.placeholder,
    this.active,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parentId'],
      categoryName: json['categoryName'] ?? '',
      categoryDescription: json['categoryDescription'],
      icon: json['icon'],
      image: json['image'],
      placeholder: json['placeholder'],
      active: json['active'],
    );
  }
}
