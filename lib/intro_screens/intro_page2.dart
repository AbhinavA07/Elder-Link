import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const Spacer(),
            Image.asset(
              'assets/intro/intro_2.jpg',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              height: 450,
            ),
            const SizedBox(
              height: 25,
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
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "ElderLink can provide a valuable solution to this problem, allowing family members and caregivers to provide support without needing to be physically present.",
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
