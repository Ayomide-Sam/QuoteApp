import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'quote_service.dart';
import 'login_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // variables to save the outputs from Quote API
  String quote = '';
  String author = '';

  // this function gets the quote and author of the quote and assigns it to the variable
  void fetchQuote() async {
    try {
      final data = await QuoteService.fetchRandomQuote();
      setState(() {
        quote = data['content'];
        author = data['author'];
      });
    } catch (e) {
      print('Failed to fetch quote: $e');
    }
  }

  // Modal for Logout feature
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
              style: TextStyle(color: Color.fromARGB(255, 25, 22, 46),)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout',
              style: TextStyle(color: Color.fromARGB(255, 25, 22, 46),)
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // the function copies the quote to clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: '$quote - $author'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied')),
    );
  }

  // the function shares the quote using different platforms
  void _shareQuote() {
    Share.share('$quote - $author');
  }

  // the UI of the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote App'),
        backgroundColor: const Color.fromARGB(255, 196, 205, 212),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            // show the modal in line 33
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container for displaying text
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 25, 22, 46),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              quote.isNotEmpty ? quote : 'Press the button to get a quote',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 196, 205, 212),),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              author.isNotEmpty ? '- $author' : '',
                              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Color.fromARGB(255, 196, 205, 212),),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.copy, color: Color.fromARGB(255, 196, 205, 212),),
                                  onPressed: _copyToClipboard,
                                ),
                                IconButton(
                                  icon: Icon(Icons.share, color: Color.fromARGB(255, 196, 205, 212),),
                                  onPressed: _shareQuote,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      // Button to fetch new quote
                      ElevatedButton(
                        onPressed: fetchQuote,
                        child: Text('Get Random Quote',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 25, 22, 46)
                        ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}