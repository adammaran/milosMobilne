import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/models/reservation_repository.dart';
import 'package:rezervacija_restorana/models/table_response.dart';
import 'package:rezervacija_restorana/repository/reservations_repository.dart';
import 'package:rezervacija_restorana/repository/tables_repository.dart';
import 'package:rezervacija_restorana/ui/all_reservation_screen.dart';
import 'package:rezervacija_restorana/ui/reservation_details_screen.dart';

class TablesScreen extends StatefulWidget {
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: FutureBuilder(
        future: TablesRepository().getTables(),
        builder: (context, AsyncSnapshot<List<TableResponse>> snapshot) {
          if (isLoading &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            debugPrint(snapshot.toString());
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      if (snapshot.data!.elementAt(index).isReserved) {
                        ReservationsRepository()
                            .getTableReservationByTableId(
                                snapshot.data!.elementAt(index).tableId!)
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReservationDetailsScreen(
                                            value,
                                            snapshot.data!
                                                .elementAt(index)
                                                .isReserved,
                                            snapshot.data!
                                                .elementAt(index)
                                                .tableId!))))
                            .then((value) => setState(() {}));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReservationDetailsScreen(
                                    null,
                                    snapshot.data!.elementAt(index).isReserved,
                                    snapshot.data!.elementAt(index).tableId!)));
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://www.apartmani-u-beogradu.com/uploads/pages/images/kafana.jpg',
                          fit: BoxFit.fill,
                        ),
                        Container(
                          width: double.infinity,
                          color: snapshot.data!.elementAt(index).isReserved
                              ? Colors.red.withOpacity(0.7)
                              : Colors.green.withOpacity(0.7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!
                                    .elementAt(index)
                                    .tableNumber
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 26),
                              ),
                              snapshot.data!.elementAt(index).isReserved
                                  ? const Text(
                                      'Rezervisano',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : const Text(
                                      'Slobodno',
                                      style: TextStyle(color: Colors.white),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
