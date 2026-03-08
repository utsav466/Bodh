import 'package:bodh_flutter/features/dashboard/domain/repositories/book_repository.dart';
import 'package:bodh_flutter/features/dashboard/models/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchBooksProvider =
    FutureProvider.autoDispose.family<List<Book>, String>((ref, query) async {
  if (query.trim().isEmpty) {
    return [];
  }

  final repository = ref.read(bookRepositoryProvider);
  return repository.searchBooks(query.trim());
});