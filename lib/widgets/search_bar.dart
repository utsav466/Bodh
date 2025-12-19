import 'package:bodh_flutter/screens/utils/responsive.dart';
import 'package:flutter/material.dart';
// import '../utils/responsive.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const SearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search books, authors…',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: isTablet ? 18 : 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      style: TextStyle(fontSize: isTablet ? 16 : 14),
    );
  }
}
