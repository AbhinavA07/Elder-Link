import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const Spacer(),
            Image.asset(
              'assets/intro/intro_1.jpg',
              // height: 250,
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
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "As the population ages, there is an ever-increasing need for care for the elderly. However, providing support for elderly people can be a challenge for family members and caregivers who may not always have the time or resources to provide round-the-clock care.",
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
