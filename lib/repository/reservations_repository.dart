import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rezervacija_restorana/models/reservation_repository.dart';
import 'package:rezervacija_restorana/repository/tables_repository.dart';

class ReservationsRepository {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('reservations');

  Future<void> addTableReservation(
      String tableId, String reservationName, String reservationTime) async {
    await collection.add({
      'tableId': tableId,
      'reservationName': reservationName,
      'reservationTime': reservationTime
    }).then((value) async {
      collection.doc(value.id).update({'reservationId': value.id});
      await FirebaseFirestore.instance
          .collection('tables')
          .doc(tableId)
          .update({'reservationId': value.id});
    });
  }

  Future<void> editTableReservation(String tableId, String reservationName,
      String reservationTime, String reservationId) async {
    collection.doc(reservationId).set({
      'tableId': tableId,
      'reservationName': reservationName,
      'reservationTime': reservationTime,
      'reservationId': reservationId
    });
  }

  Future<void> removeTableReservation(String reservationId) async {
    collection.doc(reservationId).delete();
  }

  Future<List<ReservationResponse>> getTableReservations() async {
    List<ReservationResponse> responseList = [];
    await collection.get().then((QuerySnapshot value) => {
          value.docs.forEach((element) {
            responseList.add(ReservationResponse(
                element['tableId'],
                element['reservationName'],
                element['reservationTime'],
                element['reservationId']));
          })
        });
    return responseList;
  }

  Future<ReservationResponse> getTableReservationByTableId(
      String tableId) async {
    ReservationResponse response = await collection
        .where('tableId', isEqualTo: tableId)
        .get()
        .then((value) => ReservationResponse(
            value.docs.first['tableId'],
            value.docs.first['reservationName'],
            value.docs.first['reservationTime'],
            value.docs.first['reservationId']));
    return response;
  }
}
