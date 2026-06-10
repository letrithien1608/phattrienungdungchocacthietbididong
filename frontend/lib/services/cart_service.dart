import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_client.dart';

class CartService {
  static String get baseUrl => ApiClient.baseUrl.replaceAll('/api/auth', '/api/cart');

  static Future<Map<String, dynamic>?> getCart(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print('Error getting cart: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> addToCart(String token, String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'productId': productId, 'quantity': quantity}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error adding to cart: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> updateQuantity(String token, String productId, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'productId': productId, 'quantity': quantity}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating quantity: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> removeFromCart(String token, String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/remove/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error removing from cart: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> clearCart(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/clear'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }
}
