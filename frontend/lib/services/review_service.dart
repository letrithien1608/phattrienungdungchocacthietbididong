import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_client.dart';

class ReviewService {
  static String get baseUrl => ApiClient.baseUrl.replaceAll('/api/auth', '/api/comments');

  static Future<List<dynamic>?> getReviews(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/$productId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print('Error getting reviews: $e');
      return null;
    }
  }

  static Future<bool> addReview(String token, String productId, String content, int rating, {String? image}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/product/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content': content,
          'rating': rating,
          'image': image,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error adding review: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<List<dynamic>?> getMyReviews(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/my-reviews'),
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
      print('Error getting my reviews: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }
}
