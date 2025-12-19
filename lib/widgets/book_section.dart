import 'package:bodh_flutter/screens/utils/responsive.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_card.dart';
import 'popular_book_card.dart';
import 'section_header.dart';


class BookSection extends StatelessWidget {
  final String title;
  final List<Book> books;
  final bool isLargeCard;

  const BookSection({
    super.key,
    required this.title,
    required this.books,
    this.isLargeCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return Column(
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 16),

        
        SizedBox(
          height: isLargeCard
              ? (isTablet ? 360 : 270) // was 260 → overflow fixed
              : (isTablet ? 260 : 200),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) =>
                SizedBox(width: isTablet ? 20 : 12),
            itemBuilder: (context, index) {
              return isLargeCard
                  ? PopularBookCard(book: books[index])
                  : BookCard(book: books[index]);
            },
          ),
        ),
      ],
    );
  }
}
