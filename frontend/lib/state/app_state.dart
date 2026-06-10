import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/favorite_service.dart';
import '../services/review_service.dart';
import '../services/order_service.dart';

class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({required this.product, required this.size, this.quantity = 1});
}

class ReviewData {
  final String name;
  final String date;
  final int rating;
  final String text;
  final bool hasPhotos;
  final String? imageUrl;
  final String avatarUrl;

  ReviewData({required this.name, required this.date, required this.rating, required this.text, this.hasPhotos = false, this.imageUrl, this.avatarUrl = 'https://i.pravatar.cc/150'});
}

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.status,
  });
}

class AppState extends ChangeNotifier {
  String userName = 'Guest';
  String userEmail = '';
  String userAvatar = 'https://i.pravatar.cc/150?img=12';
  String token = '';

  List<Product> favorites = [];
  List<CartItem> cart = [];
  List<Order> orders = [];
  Map<String, List<ReviewData>> productReviews = {};
  List<ReviewData> myReviews = [];

  // For Checkout/Profile
  String defaultShippingAddress = '3 Newbridge Court, Chino Hills, CA 91709, United States';
  String defaultPaymentMethod = '**** **** **** 3947';

  String appliedPromoCode = '';
  double discountPercent = 0.0;

  AppState() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('user_name') ?? 'Guest';
    userEmail = prefs.getString('user_email') ?? '';
    userAvatar = prefs.getString('user_avatar') ?? 'https://i.pravatar.cc/150?img=12';
    token = prefs.getString('token') ?? '';
    
    if (token.isNotEmpty) {
      try {
        await loadFromServer();
      } catch (e) {
        print('Could not load from server: $e');
      }
    }
    notifyListeners();
  }

  Future<void> loadFromServer() async {
    if (token.isEmpty) return;
    try {
      try {
        final favs = await FavoriteService.getFavorites(token);
        favorites = favs ?? [];
      } catch (e) {
        favorites = [];
        throw e;
      }

      final cartData = await CartService.getCart(token);
      if (cartData != null) {
        cart.clear();
        final items = cartData['items'] as List<dynamic>?;
        if (items != null) {
          for (var item in items) {
             final productJson = item['product'];
             final quantity = item['quantity'] as int;
             cart.add(CartItem(product: Product.fromJson(productJson), size: 'L', quantity: quantity));
          }
        }
      }
      
      final myReviewsData = await ReviewService.getMyReviews(token);
      if (myReviewsData != null) {
        myReviews.clear();
        for (var rev in myReviewsData) {
          myReviews.add(ReviewData(
            name: rev['user']?['fullName'] ?? userName,
            date: 'Recent',
            rating: rev['rating'] ?? 5,
            text: rev['content'] ?? '',
            hasPhotos: rev['image'] != null,
          ));
        }
      }

      final ordersData = await OrderService.getOrders(token);
      if (ordersData != null) {
        orders.clear();
        for (var orderJson in ordersData) {
          final itemsList = orderJson['items'] as List<dynamic>? ?? [];
          List<CartItem> orderItems = [];
          for (var item in itemsList) {
            if (item['product'] != null) {
              orderItems.add(CartItem(
                product: Product.fromJson(item['product']),
                size: 'L',
                quantity: item['quantity'] ?? 1,
              ));
            }
          }
          orders.add(Order(
            id: orderJson['id'].toString(),
            items: orderItems,
            totalAmount: double.tryParse(orderJson['totalAmount']?.toString() ?? '0') ?? 0,
            date: DateTime.tryParse(orderJson['date']?.toString() ?? '') ?? DateTime.now(),
            status: orderJson['status']?.toString() ?? 'Processing',
          ));
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('Load from server error: $e');
      throw e;
    }
  }

  Future<void> fetchFavorites() async {
    if (token.isEmpty) return;
    try {
      final favs = await FavoriteService.getFavorites(token);
      favorites = favs ?? [];
      notifyListeners();
    } catch (e) {
      favorites = [];
      notifyListeners();
      print('Fetch favorites error: $e');
      throw e;
    }
  }

  Future<void> setUser(String name, String email, String jwtToken, [String? avatar]) async {
    userName = name;
    token = jwtToken;
    userEmail = email;
    if (avatar != null) userAvatar = avatar;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('token', jwtToken);
    if (avatar != null) await prefs.setString('user_avatar', avatar);

    try {
      await loadFromServer();
    } catch (e) {
      print('Could not load from server during setUser: $e');
    }

    notifyListeners();
  }

  Future<void> logout() async {
    userName = 'Guest';
    userEmail = '';
    userAvatar = 'https://i.pravatar.cc/150?img=12';
    favorites.clear();
    token = '';
    cart.clear();
    orders.clear();
    myReviews.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  bool isFavorite(Product product) {
    return favorites.any((p) => p.id == product.id);
  }

  Future<void> toggleFavorite(Product product, String size) async {
    if (token.isEmpty) throw Exception('Vui lòng đăng nhập');
    if (isFavorite(product)) {
      bool success = await FavoriteService.removeFavorite(token, product.id);
      if (success) {
        favorites.removeWhere((p) => p.id == product.id);
        notifyListeners();
      } else {
        throw Exception('Lỗi server');
      }
    } else {
      bool success = await FavoriteService.addFavorite(token, product.id, size);
      if (success) {
        // Create a copy of the product with the selected size
        final favoritedProduct = Product(
          id: product.id,
          productName: product.productName,
          salePrice: product.salePrice,
          comparePrice: product.comparePrice,
          quantity: product.quantity,
          shortDescription: product.shortDescription,
          productType: product.productType,
          image: product.image,
          favoriteSize: size,
        );
        favorites.add(favoritedProduct);
        notifyListeners();
      } else {
        throw Exception('Lỗi server');
      }
    }
  }

  Future<void> addToCart(Product product, String size) async {
    if (token.isEmpty) throw Exception('Vui lòng đăng nhập');
    final existingIndex = cart.indexWhere((item) => item.product.id == product.id && item.size == size);
    int newQuantity = existingIndex >= 0 ? cart[existingIndex].quantity + 1 : 1;
    bool success;
    if (existingIndex >= 0) {
      success = await CartService.updateQuantity(token, product.id, newQuantity);
    } else {
      success = await CartService.addToCart(token, product.id, 1);
    }
    
    if (success) {
      if (existingIndex >= 0) {
        cart[existingIndex].quantity = newQuantity;
      } else {
        cart.add(CartItem(product: product, size: size));
      }
      notifyListeners();
    } else {
      throw Exception('Lỗi server');
    }
  }

  Future<void> removeFromCart(CartItem item) async {
    if (token.isEmpty) throw Exception('Vui lòng đăng nhập');
    bool success = await CartService.removeFromCart(token, item.product.id);
    if (success) {
      cart.remove(item);
      notifyListeners();
    } else {
      throw Exception('Lỗi server');
    }
  }

  Future<void> increaseQuantity(CartItem item) async {
    if (token.isEmpty) throw Exception('Vui lòng đăng nhập');
    bool success = await CartService.updateQuantity(token, item.product.id, item.quantity + 1);
    if (success) {
      item.quantity += 1;
      notifyListeners();
    } else {
      throw Exception('Lỗi server');
    }
  }

  Future<void> decreaseQuantity(CartItem item) async {
    if (token.isEmpty) throw Exception('Vui lòng đăng nhập');
    if (item.quantity > 1) {
      bool success = await CartService.updateQuantity(token, item.product.id, item.quantity - 1);
      if (success) {
        item.quantity -= 1;
        notifyListeners();
      } else {
        throw Exception('Lỗi server');
      }
    } else {
      await removeFromCart(item);
    }
  }

  double get cartTotal {
    double total = 0;
    for (var item in cart) {
      total += (item.product.salePrice) * item.quantity;
    }
    return total * (1 - discountPercent);
  }

  void applyPromoCode(String code, double percent) {
    appliedPromoCode = code;
    discountPercent = percent;
    notifyListeners();
  }

  void removePromoCode() {
    appliedPromoCode = '';
    discountPercent = 0.0;
    notifyListeners();
  }

  Future<void> checkout() async {
    if (token.isEmpty) throw Exception('Vui lòng đăng nhập');
    if (cart.isEmpty) return;
    bool success = await OrderService.checkout(token);
    if (success) {
      cart.clear();
      await loadFromServer(); // Reload orders and cart
      notifyListeners();
    } else {
      throw Exception('Lỗi server');
    }
  }

  Future<void> addReview(String productId, ReviewData review) async {
    if (token.isEmpty) throw Exception('Vui lòng đăng nhập');
    bool success = await ReviewService.addReview(token, productId, review.text, review.rating, image: review.imageUrl);
    if (success) {
      await fetchProductReviews(productId);
      await loadFromServer();
      notifyListeners();
    } else {
      throw Exception('Lỗi server');
    }
  }

  List<ReviewData> getReviews(String productId) {
    return productReviews[productId] ?? [];
  }

  Future<void> fetchProductReviews(String productId) async {
    final data = await ReviewService.getReviews(productId);
    if (data != null) {
      productReviews[productId] = data.map((rev) => ReviewData(
        name: rev['user']?['fullName'] ?? 'Anonymous',
        date: rev['createdAt']?.toString().substring(0, 10) ?? 'Recent',
        rating: rev['rating'] ?? 5,
        text: rev['content'] ?? '',
        hasPhotos: rev['image'] != null,
        imageUrl: rev['image'],
        avatarUrl: 'https://i.pravatar.cc/150?u=${rev['user']?['id'] ?? '1'}',
      )).toList();
      notifyListeners();
    }
  }

  void updateShippingAddress(String address) {
    defaultShippingAddress = address;
    notifyListeners();
  }

  void updatePaymentMethod(String method) {
    defaultPaymentMethod = method;
    notifyListeners();
  }
}
