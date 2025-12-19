import 'package:flutter/material.dart';
import 'package:bodh_flutter/models/book.dart';
import 'package:bodh_flutter/widgets/search_bar.dart' as custom_search;
import 'package:bodh_flutter/widgets/book_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Book> popularNow = [
    Book(title: 'Ikigai', subtitle: 'The Japanese Secret to a Long and Happy Life', image: 'assets/images/ikigai.jpg'),
    Book(title: 'Fourth Wing', subtitle: 'Rebecca Yarros', image: 'assets/images/RichDadPoorDad.png'),
    Book(title: 'Fourth Wing', subtitle: 'Rebecca Yarros', image: 'assets/images/automicHabits.jpg'),
    Book(title: 'The Psychology of Money', subtitle: 'Morgan Housel', image: 'assets/images/Psychology_Of_Money.png'),
    


  ];

  final List<Book> bestSelling = [
    Book(title: 'Rich Dad Poor Dad', subtitle: 'Robert Kiyosaki', image: 'assets/images/RichDadPoorDad.png'),
    Book(title: 'Atomic Habits', subtitle: 'James Clear', image: 'assets/images/automicHabits.jpg'),
  ];

  final List<Book> newest = [
    Book(title: 'The Psychology of Money', subtitle: 'Morgan Housel', image: 'assets/images/Psychology_Of_Money.png'),
    Book(title: 'Dopamine Detox', subtitle: 'Thibaut Meurisse', image: 'assets/images/Dopamine_Detox.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              custom_search.SearchBar(controller: _searchController),
              const SizedBox(height: 20),
              BookSection(title: 'Popular Now', books: popularNow, isLargeCard: true),
              const SizedBox(height: 24),
              BookSection(title: 'Best Selling', books: bestSelling),
              const SizedBox(height: 24),
              BookSection(title: 'Newest', books: newest),
            ],
          ),
        ),
      ),
    );
  }
}
