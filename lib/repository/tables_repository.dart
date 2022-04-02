import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rezervacija_restorana/models/table_response.dart';

class TablesRepository {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('tables');

  Future<List<TableResponse>> getTables() async {
    List<TableResponse> response = [];
    await collection.get().then((value) => {
          value.docs.forEach((element) {
            response.add(TableResponse(
                element['tableId'],
                element['tableNumber'],
                element['tableSize'],
                element['isReserved']));
          })
        });
    return response;
  }

  Future<void> changeTableReservation(String tableId, bool isReserved) async {
    await collection.doc(tableId).update({'isReserved': isReserved});
  }

  Future<void> addTable(String tableNumber, int tableSize) async {
    await collection.add({
      'tableNumber': tableNumber,
      'tableSize': tableSize,
      'isReserved': false
    }).then((value) => collection.doc(value.id).update({'tableId': value.id}));
  }
}
