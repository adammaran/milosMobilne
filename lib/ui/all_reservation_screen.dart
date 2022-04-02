import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/models/reservation_repository.dart';
import 'package:rezervacija_restorana/repository/reservations_repository.dart';
import 'package:rezervacija_restorana/ui/reservation_details_screen.dart';

class AllReservationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            FutureBuilder(
                future: ReservationsRepository().getTableReservations(),
                builder: (context,
                    AsyncSnapshot<List<ReservationResponse>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReservationDetailsScreen(
                                                  snapshot.data!
                                                      .elementAt(index),
                                                  true,
                                                  '')));
                                },
                                title: Text(snapshot.data!
                                    .elementAt(index)
                                    .reservationName!),
                                trailing: Text(snapshot.data!
                                    .elementAt(index)
                                    .reservationTime!),
                              ),
                            );
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
