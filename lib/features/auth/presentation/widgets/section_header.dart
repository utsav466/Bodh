import 'package:bodh_flutter/screens/utils/responsive.dart';
import 'package:flutter/material.dart';
// import '../utils/responsive.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            'See all',
            style: TextStyle(fontSize: isTablet ? 16 : 14),
          ),
        ),
      ],
    );
  }
}
