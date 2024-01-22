import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elder_link/home_page.dart';
import 'package:elder_link/services/notification_api.dart';
import 'package:elder_link/setup_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'package:path_provider/path_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isUserLoggedIn = prefs.getBool('is_logged_in') ?? false;
  _requestPermissions();
  NotificationService.initializeNotification();
  await initPathProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => SetupProvider()),
      ],
      child: MyApp(isUserLoggedIn: isUserLoggedIn),
    ),
  );
}

Future<void> _requestPermissions() async {
  await AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) async {
        if(!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
  );
  await Permission.sms.request();
  await Permission.microphone.request();
  await Permission.phone.request();
}

Future<void> initPathProvider() async {
  await getTemporaryDirectory();
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;

  const MyApp({
    Key? key,
    required this.isUserLoggedIn,
  }) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: isUserLoggedIn ? const HomePage() : const OnboardingScreen(),
    );
  }
}
