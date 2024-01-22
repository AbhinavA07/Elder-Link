import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const Spacer(),
            Image.asset(
              'assets/intro/intro_3.jpg',
              // height: 250,
            ),
            const SizedBox(
              height: 75,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "ElderLink \nHelps elders in day-to-day situations.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "An elderly care app can provide a range of features to help support the elderly. These features can vary depending on the needs of the user, but some common features include:\n\n• Reminders for medication and appointments\n• Connecting with other family members or caregivers\n• Access to medical records\n• Access to emergency services",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
