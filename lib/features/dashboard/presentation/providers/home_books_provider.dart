// import 'package:bodh_flutter/features/dashboard/data/repositories/book.repository.dart';
import 'package:bodh_flutter/features/dashboard/domain/repositories/book_repository.dart';
import 'package:bodh_flutter/features/dashboard/models/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final popularBooksProvider = FutureProvider.autoDispose<List<Book>>((ref) async {
  final repository = ref.read(bookRepositoryProvider);
  return repository.getBooks(
    page: 1,
    limit: 8,
    sort: "newest",
  );
});

final bestSellingBooksProvider =
    FutureProvider.autoDispose<List<Book>>((ref) async {
  final repository = ref.read(bookRepositoryProvider);
  return repository.getBooks(
    page: 1,
    limit: 8,
    sort: "priceDesc",
  );
});

final newestBooksProvider = FutureProvider.autoDispose<List<Book>>((ref) async {
  final repository = ref.read(bookRepositoryProvider);
  return repository.getBooks(
    page: 1,
    limit: 8,
    sort: "newest",
  );
});