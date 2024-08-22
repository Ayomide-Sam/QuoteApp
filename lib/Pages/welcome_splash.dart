import 'package:flutter/material.dart';
import 'menu_page.dart';

class MemberDetailsPage extends StatelessWidget {
  final String name;
  final String matricNumber;

  const MemberDetailsPage({
    Key? key,
    required this.name,
    required this.matricNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage()),
      );
    });

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 22, 46),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 196, 205, 212),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 196, 205, 212),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
