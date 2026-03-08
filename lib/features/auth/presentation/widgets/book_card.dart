import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:bodh_flutter/core/utils/responsive.dart';
import 'package:bodh_flutter/features/dashboard/models/book.dart';
import 'package:bodh_flutter/features/dashboard/presentation/book_details_screen.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  String _resolveImage(String image) {
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }

    if (image.startsWith('/')) {
      return '${ApiEndpoints.baseUrl}$image';
    }

    return image;
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.menu_book_outlined,
          color: Colors.grey,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildBookImage(double height) {
    if (book.image.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: _buildPlaceholder(),
      );
    }

    if (book.hasNetworkImage) {
      return Image.network(
        _resolveImage(book.image),
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return SizedBox(
            width: double.infinity,
            height: height,
            child: _buildPlaceholder(),
          );
        },
      );
    }

    return Image.asset(
      book.image,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return SizedBox(
          width: double.infinity,
          height: height,
          child: _buildPlaceholder(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Container(
        width: isTablet ? 200 : 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildBookImage(isTablet ? 140 : 100),
              ),
              const SizedBox(height: 10),
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (book.subtitle.isNotEmpty)
                Text(
                  book.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}