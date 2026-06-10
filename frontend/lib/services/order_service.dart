import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_client.dart';

class OrderService {
  static String get baseUrl => ApiClient.baseUrl.replaceAll('/api/auth', '/api/orders');

  static Future<List<dynamic>?> getOrders(String token) async {
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
      print('Error getting orders: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }

  static Future<bool> checkout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error checkout: $e');
      throw Exception('Lỗi mạng: Không thể kết nối với server.');
    }
  }
}
