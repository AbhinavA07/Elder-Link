import 'package:elder_link/appointment/appointments_for_user.dart';
import 'package:elder_link/emergency_contact/emergency_contact.dart';
import 'package:elder_link/med_record/medical_record.dart';
import 'package:elder_link/med_record/medical_record_for_user.dart';
import 'package:elder_link/medicine/medicine.dart';
import 'package:elder_link/medicine/medicine_for_user.dart';
import 'package:elder_link/onboarding_screen.dart';
import 'package:elder_link/setup_provider.dart';
import 'package:elder_link/togglemodescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appointment/appointment_database.dart';
import 'emergency_contact/emergency_contact_for_user.dart';
import 'login_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSetupMode = false;

  @override
  Widget build(BuildContext context) {
    final setupProvider = Provider.of<SetupProvider>(context);

    if(setupProvider.isSetupMode){
      return _buildAdminHomePage();
    }
    else{
      return _buildUserHomePage();
    }
  }

  Widget _buildAdminHomePage(){
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration:  const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
              stops: [0.25, 0.75],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FutureBuilder<Map<String, String>>(
            future: _loadUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final userEmail = snapshot.data?['userEmail'] ?? "User's Email";
                final userName = snapshot.data?['userName'] ?? "User's Name";
                final userPhotoUrl = snapshot.data?['userPhotoUrl'] ?? "Default Photo URL";

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(userName),
                      accountEmail: Text(userEmail),
                      currentAccountPicture: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(userPhotoUrl),
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                          image: AssetImage('assets/intro/bg3.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ToggleModeScreen()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async{
                          await LoginAPI.signOut;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
                        }
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator()); // Show loading indicator
              }
            },
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
          children: [
            Container(
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
              child: AppBar(
                title: const Text(
                  'ElderLink Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                elevation: 0, // Remove the elevation
                backgroundColor: Colors.transparent,
              ),
            ),
            const GridCardList(),
          ],
        ),
      ),
    );
  }
  }

  Widget _buildUserHomePage(){
    return Builder(
      builder: (context) {
        return Scaffold(
          drawer: Drawer(
            child: Container(
              decoration:  const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
                  stops: [0.25, 0.75],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: FutureBuilder<Map<String, String>>(
                future: _loadUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final userEmail = snapshot.data?['userEmail'] ?? "User's Email";
                    final userName = snapshot.data?['userName'] ?? "User's Name";
                    final userPhotoUrl = snapshot.data?['userPhotoUrl'] ?? "Default Photo URL";

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        UserAccountsDrawerHeader(
                          accountName: Text(userName),
                          accountEmail: Text(userEmail),
                          currentAccountPicture: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(userPhotoUrl),
                            ),
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                              image: AssetImage('assets/intro/bg3.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ToggleModeScreen()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () async{
                              await LoginAPI.signOut;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
                              },
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator(); // Show loading indicator
                  }
                },
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
              children: [
                Container(
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
                  child: AppBar(
                    title: const Text(
                      'Welcome to ElderLink',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    elevation: 0, // Remove the elevation
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const GridCardListForUser(),
              ],
            ),
          ),
        );
      }
    );
  }
  Future<Map<String, String>> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('userEmail') ?? "User's Email";
    final userName = prefs.getString('userName') ?? "User's Name";
    final userPhotoUrl = prefs.getString('userPhotoUrl') ?? "Default Photo URL";

    return {
      'userEmail': userEmail,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
    };
  }

class GridCardList extends StatelessWidget {
  const GridCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'name': 'Add Medicine',
        'subtitle': 'Manage medications',
        'icon': Icons.medication,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicinePage()));
        },
      },
      {
        'name': 'Add Emergency Contact',
        'subtitle': 'Add emergency contacts',
        'icon': Icons.emergency,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyContactPage()));
        },
      },
      {
        'name': 'Add Appointment',
        'subtitle': 'Schedule your appointments',
        'icon': Icons.calendar_today,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAppointmentPage()));
        },
      },
      {
        'name': 'Add Medical Record',
        'subtitle': 'Keep medical records',
        'icon': Icons.medical_services,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicalRecordPage()));
        },
      },
    ];

    const LinearGradient linearGradient = LinearGradient(
      colors: [Color(0xff85d1f9), Color(0xff77a8e9)],
      stops: [0.25, 0.75],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: InkWell(
                  onTap: items[index]['onTap'],
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: linearGradient,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Icon(items[index]['icon'], size: 64.0, color: Colors.white)),
                        const SizedBox(height: 16.0),
                        Text(
                          items[index]['name'],
                          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8.0),
                        Text(items[index]['subtitle'], style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GridCardListForUser extends StatelessWidget {
  const GridCardListForUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'name': 'My Medicines',
        'subtitle': 'View your medications',
        'icon': Icons.medication,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicineUser()));
        },
      },
      {
        'name': 'My Emergency Contacts',
        'subtitle': 'View emergency contacts',
        'icon': Icons.emergency,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyContactUser()));
        },
      },
      {
        'name': 'My Appointments',
        'subtitle': 'View appointments',
        'icon': Icons.calendar_today,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentsUser()));
        },
      },
      {
        'name': 'My Medical Records',
        'subtitle': 'View medical records',
        'icon': Icons.medical_services,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalRecordUser()));
        },
      },
    ];

    const LinearGradient linearGradient = LinearGradient(
      colors: [Color(0xff85d1f9), Color(0xff77a8e9)],
      stops: [0.25, 0.75],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: InkWell(
                  onTap: items[index]['onTap'],
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: linearGradient,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Icon(items[index]['icon'], size: 64.0, color: Colors.white)),
                        const SizedBox(height: 8.0),
                        Text(
                          items[index]['name'],
                          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8.0),
                        Text(items[index]['subtitle'], style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


// class VerticalCardList extends StatelessWidget {
//   const VerticalCardList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> items = [
//       {
//         'name': 'Add Medicine',
//         'subtitle': 'Manage medications',
//         'icon': Icons.medication,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicinePage()),);
//         },
//       },
//       {
//         'name': 'Add Emergency Contact',
//         'subtitle': 'Add emergency contact information',
//         'icon': Icons.emergency,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyContactPage(),),);
//         },
//       },
//       {
//         'name': 'Add Appointment',
//         'subtitle': 'Schedule your appointments',
//         'icon': Icons.calendar_today,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAppointmentPage(),),);
//         },
//       },
//       {
//         'name': 'Add Medical Record',
//         'subtitle': 'Keep medical records',
//         'icon': Icons.medical_services,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicalRecordPage(),),);
//         },
//       },
//     ];
//
//
//     final List<Widget> cards = items.map((item) {
//       return Card(
//         child: ListTile(
//           title: Text(item['name']),
//           subtitle: Text(item['subtitle']),
//           trailing: Icon(item['icon']),
//           onTap: item['onTap'],
//         ),
//       );
//     }).toList();
//
//     return Column(
//       children: cards,
//     );
//   }
// }


// class VerticalCardListForUser extends StatelessWidget {
//   const VerticalCardListForUser({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> items = [
//       {
//         'name': 'My Medicines',
//         'subtitle': 'View your medications',
//         'icon': Icons.medication,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicineUser()),);
//         },
//       },
//       {
//         'name': 'My Emergency Contacts',
//         'subtitle': 'View your emergency contacts',
//         'icon': Icons.emergency,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyContactUser()),);
//         },
//       },
//       {
//         'name': 'My Appointments',
//         'subtitle': 'View your appointments',
//         'icon': Icons.calendar_today,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentsUser()),);
//         },
//       },
//       {
//         'name': 'My Medical Records',
//         'subtitle': 'View your medical records',
//         'icon': Icons.medical_services,
//         'onTap': () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalRecordUser()),);
//         },
//       },
//     ];
//
//     final List<Widget> cards = items.map((item) {
//       return Card(
//         child: ListTile(
//           title: Text(item['name']),
//           subtitle: Text(item['subtitle']),
//           trailing: Icon(item['icon']),
//           onTap: item['onTap'],
//         ),
//       );
//     }).toList();
//
//     return Column(
//       children: cards,
//     );
//   }
// }
