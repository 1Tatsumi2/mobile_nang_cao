import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:do_an_mobile/utils/constants/api_constants.dart';

class ProductService {
  static const String baseUrl = ApiConstants.productApi;

  static Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<dynamic>> searchProducts({
    String? searchTerm,
    String? category,
    String? brand,
    String? sortOrder,
    List<String>? colors,
    List<String>? materials,
  }) async {
    final queryParameters = {
      if (searchTerm != null) 'searchTerm': searchTerm,
      if (category != null) 'category': category,
      if (brand != null) 'brand': brand,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (colors != null && colors.isNotEmpty) ...{
        for (var color in colors) 'colors': color,
      },
      if (materials != null && materials.isNotEmpty) ...{
        for (var material in materials) 'materials': material,
      },
    };

    final uri = Uri.parse('$baseUrl/Search').replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}