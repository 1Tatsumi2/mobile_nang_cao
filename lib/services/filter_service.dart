import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:do_an_mobile/utils/constants/api_constants.dart';

class FilterService {
  static Future<List<dynamic>> getFilteredProducts({
    String? searchTerm,
    String? category,
    String? brand,
    String? sortOrder,
    List<String>? colors,
    List<String>? materials,
  }) async {
    http.Client? client;
    
    try {
      client = http.Client();

      // 🔹 BUILD QUERY PARAMETERS - SỬA LẠI
      Map<String, dynamic> queryParams = {};
      
      if (searchTerm?.isNotEmpty == true) queryParams['searchTerm'] = searchTerm;
      if (category?.isNotEmpty == true) queryParams['category'] = category;
      if (brand?.isNotEmpty == true) queryParams['brand'] = brand;
      if (sortOrder?.isNotEmpty == true) queryParams['sortOrder'] = sortOrder;
      
      // 🔹 XỬ LÝ MULTIPLE VALUES - SỬA LẠI
      List<String> queryStrings = [];
      
      // Base parameters
      if (queryParams.isNotEmpty) {
        queryStrings.addAll(
          queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        );
      }
      
      // Colors
      if (colors?.isNotEmpty == true) {
        for (String color in colors!) {
          queryStrings.add('colors=${Uri.encodeComponent(color)}');
        }
      }
      
      // Materials
      if (materials?.isNotEmpty == true) {
        for (String material in materials!) {
          queryStrings.add('materials=${Uri.encodeComponent(material)}');
        }
      }

      // 🔹 BUILD FINAL URL
      String baseUrl = '${ApiConstants.productApi}/Search';
      String finalUrl = queryStrings.isNotEmpty 
          ? '$baseUrl?${queryStrings.join('&')}'
          : baseUrl;

      print('🔍 Filter request URL: $finalUrl');

      // 🔹 GỬI REQUEST
      final response = await client.get(
        Uri.parse(finalUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        print('✅ Successfully fetched ${data.length} products');
        return data;
      } else {
        print('❌ HTTP Error: ${response.statusCode} - ${response.body}');
        return []; // 🔹 TRẢ VỀ DANH SÁCH TRỐNG THAY VÌ THROW EXCEPTION
      }
      
    } on SocketException catch (e) {
      print('❌ Network error: $e');
      return []; // 🔹 TRẢ VỀ DANH SÁCH TRỐNG
    } on HttpException catch (e) {
      print('❌ HTTP error: $e');
      return [];
    } on FormatException catch (e) {
      print('❌ JSON parsing error: $e');
      return [];
    } catch (e) {
      print('❌ Unexpected error: $e');
      return [];
    } finally {
      client?.close();
    }
  }
}