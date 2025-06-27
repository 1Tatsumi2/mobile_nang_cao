import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants/api_constants.dart';
import 'auth_service.dart';

class UserService {
  // Cache cho profile data
  static Map<String, dynamic>? _cachedProfile;
  static DateTime? _lastFetchTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  static Future<Map<String, dynamic>?> getUserProfile({bool forceRefresh = false}) async {
    try {
      // Kiểm tra cache nếu không force refresh
      if (!forceRefresh && _cachedProfile != null && _lastFetchTime != null) {
        final now = DateTime.now();
        if (now.difference(_lastFetchTime!) < _cacheExpiration) {
          print('📱 Using cached profile data');
          return _cachedProfile;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) {
        print('❌ No user email found in storage');
        return null;
      }

      print('🔄 Calling GetProfile API for: $userEmail');
      
      final response = await http.get(
        Uri.parse('${ApiConstants.accountApi}/GetProfile?email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      print('API Response status: ${response.statusCode}');
      print('API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['user'] != null) {
          print('✅ Profile loaded from API: ${data['user']['avatar']}');
          
          // Update cache
          _cachedProfile = data['user'];
          _lastFetchTime = DateTime.now();
          
          return data['user'];
        }
      }
      
      print('❌ Failed to get profile from API');
      return null;
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  // Clear cache method
  static void clearProfileCache() {
    _cachedProfile = null;
    _lastFetchTime = null;
    print('🧹 Profile cache cleared');
  }

  // Update cached profile data
  static void updateCachedProfile(Map<String, dynamic> updates) {
    if (_cachedProfile != null) {
      _cachedProfile!.addAll(updates);
      print('📝 Cached profile updated: ${updates.keys}');
    }
  }

  static Future<bool> updateProfile({
    required String email,
    required String userName,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.accountApi}/UpdateProfile'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'userName': userName,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Update cached profile immediately
          updateCachedProfile({
            'userName': userName,
            'phoneNumber': phoneNumber,
          });
          
          print('✅ Profile updated successfully');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  static Future<String> uploadAvatarBytes(String email, Uint8List imageBytes) async {
    try {
      print('🔄 Uploading avatar bytes for: $email');
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.accountApi}/UploadAvatar'),
      );
      
      request.fields['email'] = email;
      request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        imageBytes,
        filename: 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ));

      final response = await request.send();
      
      print('Upload response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Upload response body: $responseData');
        
        final data = json.decode(responseData);
        if (data['success'] == true) {
          final avatarUrl = data['avatarUrl'] ?? '';
          
          // Update cached profile immediately
          updateCachedProfile({'avatar': avatarUrl});
          
          print('✅ Avatar uploaded and cache updated: $avatarUrl');
          return avatarUrl;
        }
      }
      return '';
    } catch (e) {
      print('Error uploading avatar bytes: $e');
      return '';
    }
  }

  static Future<String> uploadAvatarFile(String email, File imageFile) async {
    try {
      print('🔄 Uploading avatar file for: $email');
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.accountApi}/UploadAvatar'),
      );
      
      request.fields['email'] = email;
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        imageFile.path,
      ));

      final response = await request.send();
      
      print('Upload response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Upload response body: $responseData');
        
        final data = json.decode(responseData);
        if (data['success'] == true) {
          final avatarUrl = data['avatarUrl'] ?? '';
          
          // Update cached profile immediately
          updateCachedProfile({'avatar': avatarUrl});
          
          print('✅ Avatar uploaded and cache updated: $avatarUrl');
          return avatarUrl;
        }
      }
      return '';
    } catch (e) {
      print('Error uploading avatar file: $e');
      return '';
    }
  }

  static Future<List<Map<String, dynamic>>> getUserAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) return [];

      final response = await http.get(
        Uri.parse('${ApiConstants.accountApi}/GetUserAddresses?email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['addresses']);
        }
      }
      return [];
    } catch (e) {
      print('Error getting user addresses: $e');
      return [];
    }
  }

  static Future<bool> addAddress({
    required String email,
    required String fullName,
    required String phoneNumber,
    required String city,
    required String district,
    required String ward,
    required String detailAddress,
    bool isDefault = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.accountApi}/AddAddress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'city': city,
          'district': district,
          'ward': ward,
          'detailAddress': detailAddress,
          'isDefault': isDefault,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error adding address: $e');
      return false;
    }
  }

  static Future<bool> updateAddress({
    required int addressId,
    required String email,
    required String fullName,
    required String phoneNumber,
    required String city,
    required String district,
    required String ward,
    required String detailAddress,
    bool isDefault = false,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.accountApi}/UpdateAddress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': addressId,
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'city': city,
          'district': district,
          'ward': ward,
          'detailAddress': detailAddress,
          'isDefault': isDefault,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error updating address: $e');
      return false;
    }
  }

  static Future<bool> deleteAddress(int addressId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) return false;

      final response = await http.delete(
        Uri.parse('${ApiConstants.accountApi}/DeleteAddress?id=$addressId&email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error deleting address: $e');
      return false;
    }
  }

  static Future<bool> setDefaultAddress(int addressId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) return false;

      final response = await http.post(
        Uri.parse('${ApiConstants.accountApi}/SetDefaultAddress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'addressId': addressId,
          'email': userEmail,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error setting default address: $e');
      return false;
    }
  }
}