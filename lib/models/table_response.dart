class TableResponse {
  final String? tableId;
  final int tableNumber;
  final int tableSize;
  final String? reservationId;
  final bool isReserved;

  TableResponse(this.tableId, this.tableNumber, this.tableSize,
      this.reservationId, this.isReserved);
}
