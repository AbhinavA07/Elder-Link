import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'intro_screens/intro_page1.dart';
import 'intro_screens/intro_page2.dart';
import 'intro_screens/intro_page3.dart';
import 'login_api.dart';

class UserProvider extends ChangeNotifier{
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;
  void setUser(GoogleSignInAccount? user){
    _user = user;
    notifyListeners();
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  late GoogleSignInAccount? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = context.read<UserProvider>().user;
    if (user == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text('Skip'),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  onDotClicked: (index) => _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  ),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('showHome', true);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Login'),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text('Next'),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With Google'),
        backgroundColor: Colors.transparent,
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
      body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    var user = await LoginAPI.login();
                    if (user != null) {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('is_logged_in', true);
                      prefs.setString('userEmail', user.email);
                      prefs.setString('userName', user.displayName!);
                      prefs.setString('userPhotoUrl', user.photoUrl!);
                      Provider.of<UserProvider>(context, listen: false).setUser(user);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  },
                  child: const Text("Login Using Google"))
            ],
          )),
    );
  }
}
