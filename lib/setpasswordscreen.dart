import 'package:elder_link/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Assuming home_page.dart is in the same directory

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({Key? key}) : super(key: key);

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  late String setupPassword;

  @override
  void initState(){
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set User Password'),
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
      body:  Container(
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
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: const Icon(Icons.check_circle_outline),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter confirm password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () async {
                  final currentPassword = currentPasswordController.text;
                  final newPassword = newPasswordController.text;
                  final confirmNewPassword = confirmNewPasswordController.text;

                  if (currentPassword == setupPassword &&
                      newPassword == confirmNewPassword) {
                    // You can add additional validation if needed
                    _saveNewPassword(newPassword);

                    // Use the entered password as the setupPassword
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const PasswordScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Incorrect password or new password does not match',
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

  Future<void> _saveNewPassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('setupPassword', newPassword);
  }
}
