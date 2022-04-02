class ReservationResponse {
  late String? tableId;
  late String? reservationName;
  late String? reservationTime;
  late String? reservationId;

  ReservationResponse(this.tableId, this.reservationName, this.reservationTime,
      this.reservationId);

  ReservationResponse.empty();
}
