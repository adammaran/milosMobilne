import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/models/reservation_repository.dart';
import 'package:rezervacija_restorana/ui/all_reservation_screen.dart';
import 'package:rezervacija_restorana/ui/login_screen.dart';
import 'package:rezervacija_restorana/ui/reservation_details_screen.dart';
import 'package:rezervacija_restorana/ui/search_screen.dart';
import 'package:rezervacija_restorana/ui/tables_screen.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  List screens = [TablesScreen(), SearchScreen(), AllReservationsScreen()];
  List<String> titles = [
    'Svi stolovi',
    'Pretraga rezervacija',
    'Sve rezervacije'
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(titles.elementAt(currentIndex)),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false));
            },
            child: const Icon(Icons.logout),
          ),
          const SizedBox(width: 12)
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Stolovi'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pretraga'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Rezervacije'),
        ],
      ),
    );
  }
}
