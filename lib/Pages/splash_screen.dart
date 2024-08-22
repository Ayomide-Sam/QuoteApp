import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // updates the states
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

/* this function enables the splash screen that has "group 5" 
  to show for 4 seconds and then show Login page after 4 seconds */
  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // the below is the UI 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 22, 46),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Androids Project",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 196, 205, 212),
              ),
            ),

            Text(
              "Group 5B",
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 196, 205, 212),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
