import 'package:flutter/material.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  final List<Book> ratedBooks = const [
    Book(
      title: 'Ikigai',
      subtitle: 'The Japanese Secret to a Long and Happy Life',
      image: 'assets/images/ikigai.jpg',
      rating: 4,
    ),
    Book(
      title: 'Atomic Habits',
      subtitle: 'James Clear',
      image: 'assets/images/RichDadPoorDad.png',
      rating: 5,
    ),
    Book(
      title: 'The Psychology of Money',
      subtitle: 'Morgan Housel',
      image: 'assets/images/ikigai.jpg',
      rating: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        title: const Text(
          'Ratings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: ratedBooks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) => RatedBookCard(book: ratedBooks[index]),
      ),
    );
  }
}

class RatedBookCard extends StatelessWidget {
  final Book book;
  const RatedBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                book.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  if (book.subtitle.isNotEmpty)
                    Text(book.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.7))),
                  const SizedBox(height: 6),
                  _RatingStars(rating: book.rating),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  final int rating;
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < rating;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: const Color(0xFFFFC107),
          size: 18,
        );
      }),
    );
  }
}

class Book {
  final String title;
  final String subtitle;
  final String image;
  final int rating;

  const Book({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
  });
}
