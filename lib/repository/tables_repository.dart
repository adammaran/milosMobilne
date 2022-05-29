import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rezervacija_restorana/models/table_response.dart';
import 'package:rezervacija_restorana/repository/reservations_repository.dart';

class TablesRepository {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('tables');

  Future<List<TableResponse>> getTables() async {
    List<TableResponse> response = [];
    await collection.orderBy('tableNumber').get().then((value) => {
          value.docs.forEach((element) {
            response.add(TableResponse(
                element['tableId'],
                element['tableNumber'],
                element['tableSize'],
                element['reservationId'] ?? '',
                element['isReserved']));
          })
        });
    return response;
  }

  Future<void> changeTableReservation(String tableId, bool isReserved) async {
    await collection.doc(tableId).update({'isReserved': isReserved});
  }

  Future<void> addTable() async {
    await collection.add({
      'isReserved': false,
      'tableNumber': await findIndexForTable(),
      'tableSize': 2,
      'reservationId': ''
    }).then((value) => collection.doc(value.id).update({'tableId': value.id}));
  }

  Future<void> removeTable(TableResponse table) async {
    debugPrint(table.reservationId.toString());
    if (table.reservationId!.isNotEmpty) {
      debugPrint('removing reservation');
      await ReservationsRepository()
          .removeTableReservation(table.reservationId!);
    }
    await collection.doc(table.tableId).delete();
  }

  Future<int> findIndexForTable() async {
    List<TableResponse> tableList = await getTables();
    int newTableIndex = 1;
    for (TableResponse table in tableList) {
      if (table.tableNumber == newTableIndex) {
        newTableIndex++;
      } else if (table.tableNumber != newTableIndex) {
        if ((newTableIndex += 2) >= table.tableNumber) {
          return newTableIndex -= 2;
        }
        newTableIndex -= 2;
      }
    }
    return newTableIndex;
  }
}
