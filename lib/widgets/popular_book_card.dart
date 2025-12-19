import 'package:bodh_flutter/screens/book_details_screen.dart';
import 'package:bodh_flutter/screens/utils/responsive.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
// import '../utils/responsive.dart';

class PopularBookCard extends StatelessWidget {
  final Book book;

  const PopularBookCard({super.key, required this.book});

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
                child: Image.asset(
                  book.image,
                  width: double.infinity,
                  height: isTablet ? 220 : 180,
                  fit: BoxFit.cover,
                ),
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
