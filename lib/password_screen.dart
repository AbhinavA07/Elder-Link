import 'package:elder_link/setup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  late String setupPassword;

  @override
  void initState() {
    super.initState();
    _loadSetupPassword();
  }

  Future<void> _loadSetupPassword() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      setupPassword = prefs.getString('setupPassword') ?? ''; // Provide a default value if not found
    });
  }

  @override
  Widget build(BuildContext context) {
    final setupProvider = Provider.of<SetupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Password'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade500,
                Colors.blue.shade800,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
            stops: [0.25, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () async {
                  final enteredPassword = passwordController.text;
                  if (enteredPassword == setupPassword) {
                    setupProvider.toggleSetupMode();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Incorrect Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        elevation: 10.0,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
