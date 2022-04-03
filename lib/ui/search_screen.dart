import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/models/reservation_repository.dart';
import 'package:rezervacija_restorana/ui/reservation_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              setState(() {
                searchKeyword = value;
              });
            },
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: const InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Uneti ceo naziv rezervacije...',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                )),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchKeyword.isEmpty
                  ? FirebaseFirestore.instance
                      .collection('reservations')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('reservations')
                      .where('reservationName', isEqualTo: searchKeyword)
                      .snapshots()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(
                    child: Text('Rezervacija nije pronadjena'),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((e) {
                      ReservationResponse response = ReservationResponse(
                          e['tableId'],
                          e['reservationName'],
                          e['reservationTime'],
                          e['reservationId']);
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReservationDetailsScreen(
                                            response, true, '')));
                          },
                          title: Text(response.reservationName!),
                          trailing: Text(response.reservationTime!),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
