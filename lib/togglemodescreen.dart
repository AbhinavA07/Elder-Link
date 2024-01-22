import 'package:elder_link/password_screen.dart';
import 'package:elder_link/setpasswordscreen.dart';
import 'package:elder_link/setup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToggleModeScreen extends StatelessWidget {
  const ToggleModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final setupProvider = Provider.of<SetupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Toggle User/Admin Mode'),
              trailing: Switch(
                activeColor: Colors.blue.shade800,
                value: setupProvider.isSetupMode,
                onChanged: (value) async {
                  setupProvider.toggleSetupMode();
                  if (value) {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PasswordScreen()),);
                    if (result == null || result == false) {
                      setupProvider.toggleSetupMode();
                    }
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Set Password'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SetPasswordScreen()));
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text('Set Password'),
              ),
            ),
            // Add other settings as needed
          ],
        ),
      ),
    );
  }
}
