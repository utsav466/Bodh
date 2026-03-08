import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:bodh_flutter/core/utils/responsive.dart';
import 'package:bodh_flutter/features/dashboard/models/book.dart';
import 'package:bodh_flutter/features/dashboard/presentation/book_details_screen.dart';
import 'package:flutter/material.dart';

class PopularBookCard extends StatelessWidget {
  final Book book;

  const PopularBookCard({super.key, required this.book});

  String _resolveImage(String image) {
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }
    if (image.startsWith('/')) {
      return '${ApiEndpoints.baseUrl}$image';
    }
    return image;
  }

  Widget _buildBookImage(double height) {
    if (book.image.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.menu_book_outlined, color: Colors.grey),
        ),
      );
    }

    if (book.hasNetworkImage) {
      return Image.network(
        _resolveImage(book.image),
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
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
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, color: Colors.grey),
          ),
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
        width: isTablet ? 280 : 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 18 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _buildBookImage(isTablet ? 220 : 180),
              ),
              const SizedBox(height: 12),
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (book.subtitle.isNotEmpty)
                Text(
                  book.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 13,
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