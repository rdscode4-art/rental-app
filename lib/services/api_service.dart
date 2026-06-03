import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL
  static const String baseUrl = 'https://backend.ridealmobility.com';
  
  // API Endpoints
  static const String sendOtpEndpoint = '/owner/send-otp';
  static const String verifyOtpEndpoint = '/owner/verify-otp';
  static const String completeProfileEndpoint = '/owner/complete-profile';
  
  // Common headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Map<String, String> headersWithAuth(String token) => {
    'Authorization': 'Bearer $token',
  };

  // Send OTP API
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final url = Uri.parse('$baseUrl$sendOtpEndpoint');
      
      print('📤 Sending OTP to: $phone');
      print('🌐 URL: $url');
      
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'phone': phone}),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      print('❌ Error in sendOtp: $e');
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Verify OTP API
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final url = Uri.parse('$baseUrl$verifyOtpEndpoint');
      
      print('═══════════════════════════════════');
      print('📤 VERIFY OTP REQUEST');
      print('═══════════════════════════════════');
      print('🌐 URL: $url');
      print('📱 Phone: $phone');
      print('🔑 OTP: $otp');
      
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'phone': phone,
          'otp': otp,
        }),
      );

      print('═══════════════════════════════════');
      print('📥 VERIFY OTP RESPONSE');
      print('═══════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body:');
      print(response.body);
      print('═══════════════════════════════════');

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      print('❌ Error in verifyOtp: $e');
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Complete Profile API (Multipart)
  static Future<Map<String, dynamic>> completeProfile({
    required String token,
    required String name,
    required String email,
    required String password,
    String? agencyName,
    required String aadharNumber,
    required Map<String, String> address,
    File? profilePhoto,
    File? aadharFront,
    File? aadharBack,
    required String panNumber,
    File? panCard,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$completeProfileEndpoint');
      
      print('📤 Complete Profile Request');
      print('🌐 URL: $url');
      print('🔐 Token: $token');
      print('👤 Name: $name');
      print('📧 Email: $email');
      print('🏢 Agency: ${agencyName ?? "Not provided"}');
      print('🆔 Aadhar: $aadharNumber');
      print('📍 Address: $address');
      print('💳 PAN: $panNumber');
      
      var request = http.MultipartRequest('POST', url);
      
      // Add authorization header
      request.headers.addAll(headersWithAuth(token));
      
      // Add text fields
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      if (agencyName != null && agencyName.isNotEmpty) {
        request.fields['agencyName'] = agencyName;
      }
      request.fields['aadharNumber'] = aadharNumber;
      request.fields['panNumber'] = panNumber;
      
      // Add address fields
      request.fields['address[street]'] = address['street'] ?? '';
      request.fields['address[area]'] = address['area'] ?? '';
      request.fields['address[city]'] = address['city'] ?? '';
      request.fields['address[state]'] = address['state'] ?? '';
      request.fields['address[pincode]'] = address['pincode'] ?? '';
      
      // Add file fields
      if (profilePhoto != null) {
        print('📸 Adding profile photo: ${profilePhoto.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'profilePhoto',
          profilePhoto.path,
        ));
      }
      
      if (aadharFront != null) {
        print('🆔 Adding aadhar front: ${aadharFront.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'aadharFront',
          aadharFront.path,
        ));
      }
      
      if (aadharBack != null) {
        print('🆔 Adding aadhar back: ${aadharBack.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'aadharBack',
          aadharBack.path,
        ));
      }
      
      if (panCard != null) {
        print('💳 Adding PAN card: ${panCard.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'panCard',
          panCard.path,
        ));
      }
      
      print('🚀 Sending multipart request...');
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('═══════════════════════════════════');
      print('📥 COMPLETE PROFILE API RESPONSE');
      print('═══════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body:');
      print(response.body);
      print('═══════════════════════════════════');
      
      try {
        final responseData = json.decode(response.body);
        
        // Log errors if present
        if (response.statusCode != 200 && response.statusCode != 201) {
          print('❌ API ERROR DETECTED:');
          print('Full Response Data: $responseData');
          if (responseData['errors'] != null) {
            print('🔴 Validation Errors: ${responseData['errors']}');
          }
          if (responseData['error'] != null) {
            print('🔴 Error Field: ${responseData['error']}');
          }
          if (responseData['message'] != null) {
            print('🔴 Error Message: ${responseData['message']}');
          }
          print('═══════════════════════════════════');
        }
        
        return {
          'success': response.statusCode == 200 || response.statusCode == 201,
          'statusCode': response.statusCode,
          'data': responseData,
        };
      } catch (e) {
        print('❌ JSON Parse Error: $e');
        print('Raw Response: ${response.body}');
        return {
          'success': false,
          'statusCode': response.statusCode,
          'data': {'message': 'Invalid response format', 'raw': response.body},
        };
      }
    } catch (e) {
      print('❌ Error in completeProfile: $e');
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final requestHeaders = token != null ? headersWithAuth(token) : headers;
      
      final response = await http.get(url, headers: requestHeaders);

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final requestHeaders = token != null ? headersWithAuth(token) : headers;
      
      final response = await http.post(
        url,
        headers: requestHeaders,
        body: json.encode(body),
      );

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Generic PUT request
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final requestHeaders = token != null ? headersWithAuth(token) : headers;
      
      final response = await http.put(
        url,
        headers: requestHeaders,
        body: json.encode(body),
      );

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Generic DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final requestHeaders = token != null ? headersWithAuth(token) : headers;
      
      final response = await http.delete(url, headers: requestHeaders);

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }
}
