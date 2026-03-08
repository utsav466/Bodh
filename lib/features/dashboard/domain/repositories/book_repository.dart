import 'package:bodh_flutter/core/api/api_client.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:bodh_flutter/features/dashboard/models/book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BookRepository(apiClient);
});

class BookRepository {
  final ApiClient _apiClient;

  BookRepository(this._apiClient);

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.books,
        queryParameters: {
          "search": query,
          "limit": 20,
          "page": 1,
          "sort": "newest",
        },
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid response format");
      }

      final items = data["items"];

      if (items is! List) {
        return [];
      }

      return items
          .map((item) => Book.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Failed to search books";
      throw Exception(message);
    } catch (_) {
      throw Exception("Failed to search books");
    }
  }

  Future<List<Book>> getBooks({
    String? search,
    String? category,
    int page = 1,
    int limit = 10,
    String sort = "newest",
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.books,
        queryParameters: {
          "search": search,
          "category": category,
          "page": page,
          "limit": limit,
          "sort": sort,
        }..removeWhere((key, value) => value == null || value == ""),
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid response format");
      }

      final items = data["items"];

      if (items is! List) {
        return [];
      }

      return items
          .map((item) => Book.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Failed to fetch books";
      throw Exception(message);
    } catch (_) {
      throw Exception("Failed to fetch books");
    }
  }
}