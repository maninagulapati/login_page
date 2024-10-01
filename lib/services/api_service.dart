import 'package:dio/dio.dart';

class ApiService {
  Dio _dio = Dio();

  ApiService() {
    // Set up Dio options, such as base URL and headers.
    _dio.options = BaseOptions(
      baseUrl: "http://localhost:3000",
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } catch (error) {
      throw Exception("Failed to fetch data: $error");
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (error) {
      throw Exception("Failed to post data: $error");
    }
  }

  Future<Response> putRequest(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } catch (error) {
      throw Exception("Failed to update data: $error");
    }
  }

  Future<Response> deleteRequest(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response;
    } catch (error) {
      throw Exception("Failed to delete data: $error");
    }
  }

  //patch request
  Future<Response> patchRequest(String endpoint, dynamic data) async {
  
   try {
      final response = await _dio.patch(endpoint, data: data);
      return response;
    } catch (error) {
      throw Exception("Failed to update data: $error");
    }
  }
}
