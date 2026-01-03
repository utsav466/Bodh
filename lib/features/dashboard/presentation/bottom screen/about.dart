import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About BODH',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👨‍💻 About Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 8),
                Text('Developed by Utsav Thapa'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 8),
                Text('support@bodhbookstore.com'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 8),
                Text('Kathmandu, Nepal'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}