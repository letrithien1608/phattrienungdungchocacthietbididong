import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../api_client.dart';

class ProductService {
  Future<List<Product>> getNewProducts() async {
    try {
      final baseUrl = ApiClient.baseUrl.replaceAll('/api/auth', '/api/products');
      final response = await http.get(Uri.parse('$baseUrl/new'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load new products');
      }
    } catch (e) {
      print('Error fetching new products: $e');
      return [];
    }
  }

  Future<List<Product>> getSaleProducts() async {
    try {
      final baseUrl = ApiClient.baseUrl.replaceAll('/api/auth', '/api/products');
      final response = await http.get(Uri.parse('$baseUrl/sale'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sale products');
      }
    } catch (e) {
      print('Error fetching sale products: $e');
      return [];
    }
  }
  Future<List<Product>> getAllProducts() async {
    try {
      final baseUrl = ApiClient.baseUrl.replaceAll('/api/auth', '/api/products');
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        // Có thể API trả về Pageable object thay vì List, tuỳ theo cấu hình backend
        // Tạm thời xử lý dạng List
        final dynamic decoded = json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> jsonList = [];
        if (decoded is List) {
           jsonList = decoded;
        } else if (decoded is Map && decoded['content'] != null) {
           jsonList = decoded['content'];
        }
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}
