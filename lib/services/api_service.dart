import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Base URL
  static const String baseUrl = 'https://backend.ridealmobility.com';

  // API Endpoints
  static const String sendOtpEndpoint = '/owner/send-otp';
  static const String verifyOtpEndpoint = '/owner/verify-otp';
  static const String completeProfileEndpoint = '/owner/complete-profile';
  static const String loginEndpoint = '/owner/login';
  static const String forgotPasswordSendOtpEndpoint =
      '/owner/forgot-password/send-otp';
  static const String forgotPasswordVerifyOtpEndpoint =
      '/owner/forgot-password/verify-otp';
  static const String forgotPasswordResetEndpoint =
      '/owner/forgot-password/reset';
  // Add Vehicle API
  static const String addVehicleEndpoint = '/owner/vehicle/add';
  static const String getVehiclesEndpoint = '/owner/vehicles';
  static const String profileEndpoint = '/owner/profile';
  static const String ownerBookingRequestsEndpoint =
      '/api/vehicle-bookings/owner/requests';

  // Common headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Map<String, String> headersWithAuth(String token) => {
    'Authorization': 'Bearer $token',
  };

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      return json.decode(response.body);
    } catch (_) {
      return {'message': 'Invalid response format', 'raw': response.body};
    }
  }

  // Login API
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$loginEndpoint');
      final fcmToken = await FirebaseMessaging.instance.getToken();

      print('═══════════════════════════════════');
      print('📤 LOGIN REQUEST');
      print('═══════════════════════════════════');
      print('🌐 URL: $url');
      print('📧 Email: $email');
      print('🔒 Password: ${password.substring(0, 3)}***');
      print('📱 FCM Token: $fcmToken');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'email': email,
          'password': password,
          'fcmToken': fcmToken,
        }),
      );

      print('═══════════════════════════════════');
      print('📥 LOGIN RESPONSE');
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
      print('❌ Error in login: $e');
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error: $e'},
        'error': e.toString(),
      };
    }
  }

  // Get Profile API
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl$profileEndpoint');

      print('═══════════════════════════════════');
      print('📤 GET PROFILE REQUEST');
      print('═══════════════════════════════════');
      print('🌐 URL: $url');
      print('🔑 Token: ${token.substring(0, 30)}...');

      final response = await http.get(url, headers: headersWithAuth(token));

      print('═══════════════════════════════════');
      print('📥 GET PROFILE RESPONSE');
      print('═══════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body:');
      print(response.body);
      print('═══════════════════════════════════');

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      print('❌ Error in getProfile: $e');
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

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
  static Future<Map<String, dynamic>> verifyOtp(
    String phone,
    String otp,
  ) async {
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
        body: json.encode({'phone': phone, 'otp': otp}),
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

  // Forgot Password - Send OTP API
  static Future<Map<String, dynamic>> sendForgotPasswordOtp(
    String phone,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$forgotPasswordSendOtpEndpoint');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'phone': phone}),
      );

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'statusCode': response.statusCode,
        'data': _decodeResponse(response),
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

  // Forgot Password - Verify OTP API
  static Future<Map<String, dynamic>> verifyForgotPasswordOtp(
    String phone,
    String otp,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$forgotPasswordVerifyOtpEndpoint');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'phone': phone, 'otp': otp}),
      );

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'statusCode': response.statusCode,
        'data': _decodeResponse(response),
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

  // Forgot Password - Reset Password API
  static Future<Map<String, dynamic>> resetForgotPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$forgotPasswordResetEndpoint');

      final response = await http.post(
        url,
        headers: {...headers, ...headersWithAuth(resetToken)},
        body: json.encode({
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'statusCode': response.statusCode,
        'data': _decodeResponse(response),
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

  // Complete Profile API (Multipart)
  static Future<Map<String, dynamic>> completeProfile({
    required String token,
    required String name,
    required String email,
    required String password,
    String? agencyName,
    required String aadharNumber,
    required Map<String, String> address,
    required String lat,
    required String lng,
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
      request.fields['lat'] = lat;
      request.fields['lng'] = lng;

      // Add file fields
      if (profilePhoto != null) {
        print('📸 Adding profile photo: ${profilePhoto.path}');
        final extension = profilePhoto.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';

        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'webp') {
          mimeType = 'image/webp';
        } else if (extension == 'heic') {
          mimeType = 'image/heic';
        }

        print('🎨 MIME Type: $mimeType');

        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePhoto',
            profilePhoto.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      if (aadharFront != null) {
        print('🆔 Adding aadhar front: ${aadharFront.path}');
        final extension = aadharFront.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';

        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'webp') {
          mimeType = 'image/webp';
        } else if (extension == 'heic') {
          mimeType = 'image/heic';
        }

        print('🎨 MIME Type: $mimeType');

        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharFront',
            aadharFront.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      if (aadharBack != null) {
        print('🆔 Adding aadhar back: ${aadharBack.path}');
        final extension = aadharBack.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';

        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'webp') {
          mimeType = 'image/webp';
        } else if (extension == 'heic') {
          mimeType = 'image/heic';
        }

        print('🎨 MIME Type: $mimeType');

        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharBack',
            aadharBack.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      if (panCard != null) {
        print('💳 Adding PAN card: ${panCard.path}');
        final extension = panCard.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';

        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'webp') {
          mimeType = 'image/webp';
        } else if (extension == 'heic') {
          mimeType = 'image/heic';
        }

        print('🎨 MIME Type: $mimeType');

        request.files.add(
          await http.MultipartFile.fromPath(
            'panCard',
            panCard.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
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

  // Get Vehicles API
  static Future<Map<String, dynamic>> getVehicles(String token) async {
    try {
      final url = Uri.parse('$baseUrl$getVehiclesEndpoint');

      print('═══════════════════════════════════');
      print('📤 GET VEHICLES REQUEST');
      print('═══════════════════════════════════');
      print('🌐 URL: $url');
      print('🔑 Token: ${token.substring(0, 30)}...');

      final response = await http.get(url, headers: headersWithAuth(token));

      print('═══════════════════════════════════');
      print('📥 GET VEHICLES RESPONSE');
      print('═══════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body:');
      print(response.body);
      print('═══════════════════════════════════');

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };
    } catch (e) {
      print('❌ Error in getVehicles: $e');
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Get Owner Booking Requests API
  static Future<Map<String, dynamic>> getOwnerBookingRequests(
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$ownerBookingRequestsEndpoint');

      final response = await http.get(url, headers: headersWithAuth(token));

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'data': _decodeResponse(response),
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

  // Add Vehicle API (Multipart)
  static Future<Map<String, dynamic>> addVehicle({
    required String token,
    required String model,
    required String numberPlate,
    required String type,
    required String registrationDate,
    required String color,
    required String seatingCapacity,
    required String fuelType,
    required String hourlyRate,
    required String dailyRate,
    required List<File> images,
    File? rc,
    File? insurance,
    File? pollution,
    File? fitness,
    File? permit,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$addVehicleEndpoint');

      print('═══════════════════════════════════');
      print('📤 ADD VEHICLE REQUEST');
      print('═══════════════════════════════════');
      print('🌐 URL: $url');
      print('🚗 Model: $model');
      print('🔢 Number Plate: $numberPlate');
      print('🏷️ Type: $type');
      print('📅 Registration Date: $registrationDate');
      print('🎨 Color: $color');
      print('💺 Seating Capacity: $seatingCapacity');
      print('⛽ Fuel Type: $fuelType');
      print('📸 Images count: ${images.length}');

      var request = http.MultipartRequest('POST', url);

      // Add authorization header
      request.headers.addAll(headersWithAuth(token));

      // Add text fields
      request.fields['model'] = model;
      request.fields['numberPlate'] = numberPlate;
      request.fields['type'] = type;
      request.fields['registrationDate'] = registrationDate;
      request.fields['color'] = color;
      request.fields['seatingCapacity'] = seatingCapacity;
      request.fields['fuelType'] = fuelType;
      request.fields['hourlyRate'] = hourlyRate;
      request.fields['dailyRate'] = dailyRate;

      // Add vehicle images (multiple)
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        print('📸 Adding image ${i + 1}: ${file.path}');

        final extension = file.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';

        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'webp') {
          mimeType = 'image/webp';
        } else if (extension == 'heic') {
          mimeType = 'image/heic';
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      // Add document files
      if (rc != null) {
        print('📄 Adding RC document');
        request.files.add(
          await http.MultipartFile.fromPath(
            'rc',
            rc.path,
            contentType: MediaType.parse(_getMimeType(rc.path)),
          ),
        );
      }

      if (insurance != null) {
        print('📄 Adding Insurance document');
        request.files.add(
          await http.MultipartFile.fromPath(
            'insurance',
            insurance.path,
            contentType: MediaType.parse(_getMimeType(insurance.path)),
          ),
        );
      }

      if (pollution != null) {
        print('📄 Adding Pollution document');
        request.files.add(
          await http.MultipartFile.fromPath(
            'pollution',
            pollution.path,
            contentType: MediaType.parse(_getMimeType(pollution.path)),
          ),
        );
      }

      if (fitness != null) {
        print('📄 Adding Fitness document');
        request.files.add(
          await http.MultipartFile.fromPath(
            'fitness',
            fitness.path,
            contentType: MediaType.parse(_getMimeType(fitness.path)),
          ),
        );
      }

      if (permit != null) {
        print('📄 Adding Permit document');
        request.files.add(
          await http.MultipartFile.fromPath(
            'permit',
            permit.path,
            contentType: MediaType.parse(_getMimeType(permit.path)),
          ),
        );
      }

      print('🚀 Sending add vehicle request...');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('═══════════════════════════════════');
      print('📥 ADD VEHICLE RESPONSE');
      print('═══════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body:');
      print(response.body);
      print('═══════════════════════════════════');

      try {
        final responseData = json.decode(response.body);

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
      print('❌ Error in addVehicle: $e');
      return {
        'success': false,
        'statusCode': 0,
        'data': {'message': 'Network error. Please check your connection.'},
        'error': e.toString(),
      };
    }
  }

  // Helper method to get MIME type
  static String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();

    if (extension == 'png') return 'image/png';
    if (extension == 'jpg' || extension == 'jpeg') return 'image/jpeg';
    if (extension == 'webp') return 'image/webp';
    if (extension == 'heic') return 'image/heic';
    if (extension == 'pdf') return 'application/pdf';

    return 'image/jpeg'; // default
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
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
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
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
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
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
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
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
