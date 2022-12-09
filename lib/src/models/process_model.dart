class ProcessModel {
  String uuid;
  int arrivalTime;
  double processTime;
  int processQueueNumber;

  ProcessModel({
    required this.uuid,
    required this.arrivalTime,
    required this.processTime,
    this.processQueueNumber = -1,
  });

  ProcessModel.duplicate(ProcessModel model)
      : this(
          uuid: model.uuid,
          arrivalTime: model.arrivalTime,
          processTime: model.processTime,
          processQueueNumber: model.processQueueNumber,
        );

  @override
  String toString() {
    return "ArrivalTime: $arrivalTime, ProcessTime: $processTime, ProcessQueueNumber: $processQueueNumber";
  }
}
