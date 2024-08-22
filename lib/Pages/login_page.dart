import 'package:flutter/material.dart';
import 'welcome_splash.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// define variable to store input
class User {
  final String matricno;

  User({
    required this.matricno,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['matricno'] == null) {
      throw Exception('Invalid JSON data');
    }
    return User(
      matricno: json['matricno'] as String,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _matricnoController = TextEditingController();

  @override
  void dispose() {
    _matricnoController.dispose();
    super.dispose();
  }

  /* the below function accepts the matric number from login page and then 
  sends it to the API and waits for a response*/
  Future<Map<String, dynamic>?> loginUser(String matricno) async {
    const String apiUrl = 'https://app.ciphernetsandbox.com.ng/public/loginMember';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'matricno': matricno,
      }),
    );

    // check for the response
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        return responseData['data']; // data here is the name with the matric number posted
        
      } else {
        _showErrorDialog(responseData['message']); // if matric number doesn't show a message also gotten from the api
        return null;
      }
    } else {
      _showErrorDialog('Failed to log in. Status: ${response.statusCode}, Body: ${response.body}');
      return null;
    }
  }

  // the UI for the error message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message), // the message provided by the api in line 65 and 69
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loginForm() async {
    if (_formKey.currentState!.validate()) {
      // it calls the loginUser function on line 43 and assigns it values to loginData
      final loginData = await loginUser(_matricnoController.text);

      // if value is not 'null' navigate to the next page and make use of the values
      if (loginData != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MemberDetailsPage(
              name: loginData['name'],
              matricNumber: loginData['matric_number'],
            ),
          ),
        );
      }
    }
  }

// the below is the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 196, 205, 212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double width;
                if (constraints.maxWidth < 600) {
                  // For mobile devices
                  width = constraints.maxWidth * 0.8;
                } else {
                  // For tablets and desktops
                  width = constraints.maxWidth * 0.6;
                }
                return Container(
                  width: width,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _matricnoController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Matric number',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 9, 56, 94),
                          fontSize: 15,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 9, 56, 94), width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                      // the below ensures the textfield has a value before it passes
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Matric Number';
                        }
                        return null;
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                /* on pressing the login button provided that the textfield has a value
                it calls the _loginForm function which is on line 93*/
                _loginForm();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 25, 22, 46)),
                foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 226, 226, 226)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
