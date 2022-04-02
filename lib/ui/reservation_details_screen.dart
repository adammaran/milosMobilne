import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/models/reservation_repository.dart';
import 'package:rezervacija_restorana/repository/reservations_repository.dart';
import 'package:rezervacija_restorana/repository/tables_repository.dart';
import 'package:rezervacija_restorana/ui/dashboard.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReservationDetailsScreen extends StatelessWidget {
  late ReservationResponse? reservation;
  final bool isReserved;
  final String tableId;

  ReservationDetailsScreen(this.reservation, this.isReserved, this.tableId);

  TextEditingController nameController = TextEditingController();
  String selectedDateTime = '';

  @override
  Widget build(BuildContext context) {
    if (isReserved) {
      nameController.text = reservation!.reservationName!;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Nova rezervacija')),
      body: Container(
        padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              controller: nameController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.label),
                  hintText: "Ime rezervcije",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  )),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              initialValue: isReserved
                  ? reservation!.reservationTime
                  : DateTime.now().toString(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2032),
              dateLabelText: 'Datum',
              timeLabelText: "Sati",
              onChanged: (val) => {selectedDateTime = val},
              onSaved: (val) => {selectedDateTime = val!},
            ),
            ElevatedButton(
                onPressed: () {
                  if (isReserved) {
                    ReservationsRepository()
                        .editTableReservation(
                            reservation!.tableId!,
                            nameController.text,
                            selectedDateTime,
                            reservation!.reservationId!)
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()),
                            (Route<dynamic> route) => false));
                  } else {
                    ReservationsRepository()
                        .addTableReservation(
                            tableId,
                            nameController.text,
                            selectedDateTime == ''
                                ? DateTime.now().toString()
                                : selectedDateTime)
                        .then((value) => {
                              TablesRepository()
                                  .changeTableReservation(tableId, !isReserved)
                            })
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()),
                            (Route<dynamic> route) => false));
                  }
                },
                child: isReserved ? const Text('Izmeni') : const Text('Dodaj')),
            if (isReserved)
              ElevatedButton(
                  onPressed: () {
                    ReservationsRepository()
                        .removeTableReservation(reservation!.reservationId!)
                        .then((value) => TablesRepository()
                            .changeTableReservation(tableId, !isReserved))
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()),
                            (Route<dynamic> route) => false));
                  },
                  child: const Text('Obrisi'))
          ],
        ),
      ),
    );
  }
}
