import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_client.dart';
import '../models/product.dart';

class FavoriteService {
  static String get baseUrl => ApiClient.baseUrl.replaceAll('/api/auth', '/api/favorites');

  static Future<List<Product>?> getFavorites(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Product.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('Error getting favorites: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> addFavorite(String token, String productId, String size) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'productId': productId, 'size': size}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error adding favorite: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> removeFavorite(String token, String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error removing favorite: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> checkFavorite(String token, String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/check/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      }
      return false;
    } catch (e) {
      print('Error checking favorite: $e');
      return false; // Silently fail check
    }
  }
}
