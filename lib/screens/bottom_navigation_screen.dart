import 'package:bodh_flutter/screens/bottom%20screen/about.dart';
import 'package:bodh_flutter/screens/bottom%20screen/cart.dart';
import 'package:bodh_flutter/screens/bottom%20screen/home.dart';
import 'package:bodh_flutter/screens/bottom%20screen/profile.dart';
import 'package:flutter/material.dart';



class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const CartScreen(),
    const ProfileScreen(),
    const AboutScreen(),
  ]; //  <-- Missing semicolon FIXED!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('This is dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: lstBottomScreen[_selectedIndex], // <-- Shows the correct page

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.car_crash), label: 'About'),
        ],
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}