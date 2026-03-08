import 'dart:async';

import 'package:bodh_flutter/features/auth/presentation/widgets/book_section.dart';
import 'package:bodh_flutter/features/auth/presentation/widgets/search_bar.dart'
    as custom_search;
import 'package:bodh_flutter/features/dashboard/models/book.dart';
import 'package:bodh_flutter/features/dashboard/presentation/providers/book_search_provider.dart';
import 'package:bodh_flutter/features/dashboard/presentation/providers/home_books_provider.dart';
import 'package:bodh_flutter/features/dashboard/presentation/sensor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SensorService _sensorService = SensorService();

  Timer? _debounce;
  String _debouncedQuery = "";

  bool get _isSearching => _debouncedQuery.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _sensorService.startAccelerometer(
      onShake: _handleShakeRefresh,
    );

    _sensorService.startGyroscope(
      onTilt: _handleTilt,
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() {
        _debouncedQuery = value.trim();
      });
    });

    setState(() {});
  }

  void _handleShakeRefresh() {
    ref.invalidate(popularBooksProvider);
    ref.invalidate(bestSellingBooksProvider);
    ref.invalidate(newestBooksProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Phone shaken! Book list refreshed.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTilt(double x, double y, double z) {
    if (!mounted) return;

    String direction = 'Device tilted';

    if (x > 3) {
      direction = 'Phone tilted right';
    } else if (x < -3) {
      direction = 'Phone tilted left';
    } else if (y > 3) {
      direction = 'Phone tilted forward';
    } else if (y < -3) {
      direction = 'Phone tilted backward';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(direction),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildSearchLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSearchError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            'Search failed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'No books found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try searching by title, author, or category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Book> books) {
    return BookSection(
      title: 'Search Results',
      books: books,
      isLargeCard: true,
    );
  }

  Widget _buildSectionAsync({
    required String title,
    required AsyncValue<List<Book>> asyncBooks,
    bool isLargeCard = false,
  }) {
    return asyncBooks.when(
      data: (books) {
        if (books.isEmpty) {
          return const SizedBox.shrink();
        }

        return BookSection(
          title: title,
          books: books,
          isLargeCard: isLargeCard,
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _sensorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchBooksProvider(_debouncedQuery));
    final popularAsync = ref.watch(popularBooksProvider);
    final bestSellingAsync = ref.watch(bestSellingBooksProvider);
    final newestAsync = ref.watch(newestBooksProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              custom_search.SearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 20),
              if (_isSearching)
                searchAsync.when(
                  data: (books) {
                    if (books.isEmpty) {
                      return _buildSearchEmpty();
                    }
                    return _buildSearchResults(books);
                  },
                  loading: _buildSearchLoading,
                  error: (error, _) => _buildSearchError(error.toString()),
                )
              else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sensor Features',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text('• Shake phone to refresh books'),
                      Text('• Tilt phone to detect movement'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionAsync(
                  title: 'Popular Now',
                  asyncBooks: popularAsync,
                  isLargeCard: true,
                ),
                const SizedBox(height: 24),
                _buildSectionAsync(
                  title: 'Best Selling',
                  asyncBooks: bestSellingAsync,
                ),
                const SizedBox(height: 24),
                _buildSectionAsync(
                  title: 'Newest',
                  asyncBooks: newestAsync,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}