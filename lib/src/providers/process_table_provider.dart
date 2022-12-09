import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/process_model.dart';

final processTableProvider =
    ChangeNotifierProvider<ProcessTableProvider>((ref) {
  return ProcessTableProvider(ref);
});

class ProcessTableProvider extends ChangeNotifier {
  final Ref ref;
  ProcessTableProvider(this.ref);

  final List<ProcessModel> _testCase1 = [
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 0,
      processTime: 12,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 2,
      processTime: 4,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 10,
      processTime: 10,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 26,
      processTime: 8,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 35,
      processTime: 11,
    ),
  ];

  final List<ProcessModel> _testCase2 = [
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 0,
      processTime: 16,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 2,
      processTime: 8,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 5,
      processTime: 2,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 8,
      processTime: 16,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 11,
      processTime: 3,
    ),
  ];

  final List<ProcessModel> _processList = [
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 0,
      processTime: 16,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 2,
      processTime: 8,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 5,
      processTime: 2,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 8,
      processTime: 16,
    ),
    ProcessModel(
      uuid: const Uuid().v4(),
      arrivalTime: 11,
      processTime: 3,
    ),
  ];
  List<ProcessModel> get processList => _processList;

  void add({required int arrivalTime, required int processTime}) {
    _processList.add(
      ProcessModel(
        uuid: const Uuid().v4(),
        arrivalTime: arrivalTime,
        processTime: processTime.toDouble(),
      ),
    );

    notifyListeners();
  }

  void delete({required String processUUID}) {
    _processList.removeWhere((element) => element.uuid == processUUID);

    notifyListeners();
  }
}
