import 'package:flutter/material.dart';
//import 'my_login_page.dart'; // Import your MyLoginPage class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: MyLoginPage(), // Set MyLoginPage as the home screen
    );
  }
}

// my_login_page.dart (unchanged)

class MyLoginPage extends StatefulWidget {
  @override
   createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool _useOtpVerification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            if (_useOtpVerification)
              TextField(
                decoration: InputDecoration(labelText: 'OTP'),
              ),
            Row(
              children: [
                Checkbox(
                  value: _useOtpVerification,
                  onChanged: (value) => setState(() => _useOtpVerification = value!),
                ),
                Text('Use OTP Verification'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Handle login logic based on chosen verification method
                if (_useOtpVerification) {
                  // Handle sending OTP and processing OTP input
                } else {
                  // Handle alternative verification method (e.g., email)
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Inform user how to enable built-in OTP autofill (Android 8+)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Enable OTP Autofill'),
                    content: Text('To avoid manually entering OTPs, go to your Android settings and enable OTP Autofill for this app.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Learn about OTP Autofill'),
            ),
          ],
        ),
      ),
    );
  }
}
