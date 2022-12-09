import 'dart:collection';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:cpu_scheduling/src/providers/process_table_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/process_model.dart';
import '../widgets/processbar.dart';

final algoProvider = ChangeNotifierProvider<AlgoProvider>((ref) {
  return AlgoProvider(ref);
});

class AlgoProvider extends ChangeNotifier {
  final Ref ref;
  AlgoProvider(this.ref);

  final List<ProcessBar> _progressBar = [];
  List<ProcessBar> get progressBar => _progressBar;

  double _waitTime = 0;
  double get waitTime => _waitTime;

  double _avgWaitTime = 0;
  double get avgWaitTime => _avgWaitTime;

  double _burstTime = 0;
  double get burstTime => _burstTime;

  double _avgBurstTime = 0;
  double get avgBurstTime => _avgBurstTime;

  void FCFS() {
    _progressBar.clear();
    final provider = ref.read(processTableProvider);

    int totalArrivalTime = 0;
    int totalWait = 0;
    int totalBurst = 0;

    List<Color> colors = List.generate(
      provider.processList.length,
      (index) => Color((Random(index).nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
    );

    provider.processList.asMap().forEach((index, element) {
      //Add Blank Process
      if (element.arrivalTime > totalArrivalTime) {
        int time = element.arrivalTime - totalArrivalTime;
        _progressBar.add(
          ProcessBar(
            start: totalArrivalTime,
            end: totalArrivalTime + time,
            text: "",
            color: Colors.grey,
          ),
        );

        totalArrivalTime += time;
      }

      if (element.arrivalTime < totalArrivalTime) {
        totalWait += totalArrivalTime - element.arrivalTime;
      }

      print('BURST $totalArrivalTime');
      totalBurst += totalArrivalTime;

      _progressBar.add(
        ProcessBar(
          start: totalArrivalTime,
          end: totalArrivalTime + element.processTime.toInt(),
          text: "P${index + 1}",
          color: colors[index],
        ),
      );

      totalArrivalTime += element.processTime.toInt();
    });

    _waitTime = totalWait.toDouble();
    _avgWaitTime = totalWait / provider.processList.length;

    _burstTime = totalBurst.toDouble();
    _avgBurstTime = totalBurst / provider.processList.length;

    notifyListeners();
  }

  void SJFNonEmptive() {
    _progressBar.clear();
    final provider = ref.read(processTableProvider);
    List<ProcessModel> processList =
        provider.processList.map((e) => ProcessModel.duplicate(e)).toList();

    int totalArrivalTime = 0;
    int totalWait = 0;
    int totalBurst = 0;

    List<Color> colors = List.generate(
      processList.length,
      (index) => Color((Random(index).nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
    );

    processList.asMap().forEach((index, element) {
      //Add Blank Process
      if (element.arrivalTime > totalArrivalTime) {
        int time = element.arrivalTime - totalArrivalTime;
        _progressBar.add(
          ProcessBar(
            start: totalArrivalTime,
            end: totalArrivalTime + time,
            text: "",
            color: Colors.grey,
          ),
        );

        totalArrivalTime += time;
      }

      if (element.arrivalTime < totalArrivalTime) {
        totalWait += totalArrivalTime - element.arrivalTime;
      }

      print('BURST $totalArrivalTime');
      totalBurst += totalArrivalTime;

      _progressBar.add(
        ProcessBar(
          start: totalArrivalTime,
          end: totalArrivalTime + element.processTime.toInt(),
          text: "P${index + 1}",
          color: colors[index],
        ),
      );

      totalArrivalTime += element.processTime.toInt();
    });

    _waitTime = totalWait.toDouble();
    _avgWaitTime = totalWait / processList.length;

    _burstTime = totalBurst.toDouble();
    _avgBurstTime = totalBurst / processList.length;

    notifyListeners();
  }

  void SJFPreEmptive() {
    _progressBar.clear();
    final provider = ref.read(processTableProvider);
    List<ProcessModel> processList =
        provider.processList.map((e) => ProcessModel.duplicate(e)).toList();

    int totalArrivalTime = 0;
    double totalWait = 0;
    int totalBurst = 0;

    List<Color> colors = List.generate(
      processList.length,
      (index) => Color((Random(index).nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
    );

    int count = 0;

    ProcessModel delayProcess = ProcessModel(
      arrivalTime: 0,
      processTime: double.infinity,
      processQueueNumber: -1,
      uuid: const Uuid().v4(),
    );
    ProcessModel currentProcess = delayProcess;

    int currentWork = 0;
    Queue<ProcessModel> backlog = Queue();

    while (true) {
      if (currentProcess.processTime == 0) {
        _progressBar.add(
          ProcessBar(
            start: totalArrivalTime - currentWork,
            end: totalArrivalTime,
            text: currentProcess.processQueueNumber != -1
                ? "P${currentProcess.processQueueNumber + 1}"
                : "",
            color: currentProcess.processQueueNumber != -1
                ? colors[currentProcess.processQueueNumber]
                : Colors.grey,
          ),
        );

        dev.log(
            "Finished P${currentProcess.processQueueNumber + 1}, saving work ($currentWork) in bar");
        currentWork = 0;

        if (backlog.isNotEmpty) {
          print('BURST $totalArrivalTime');
          totalBurst += totalArrivalTime;

          currentProcess = backlog.removeLast();
          dev.log("Starting P${currentProcess.processQueueNumber + 1} again");
        } else {
          dev.log("Queue, is empty, starting delay task");
          currentProcess = delayProcess;
        }
      }

      if (count <= processList.length - 1) {
        while (processList[count].arrivalTime <= totalArrivalTime) {
          dev.log(
              "Starting process P${count + 1} ${processList[count].toString()} at time $totalArrivalTime");
          processList[count].processQueueNumber = count;

          dev.log(currentProcess.processTime.toString());
          if (processList[count].processTime < currentProcess.processTime) {
            if (currentWork != 0) {
              _progressBar.add(
                ProcessBar(
                  start: totalArrivalTime - currentWork,
                  end: totalArrivalTime,
                  text: currentProcess.processQueueNumber != -1
                      ? "P${currentProcess.processQueueNumber + 1}"
                      : "",
                  color: currentProcess.processQueueNumber != -1
                      ? colors[currentProcess.processQueueNumber]
                      : Colors.grey,
                ),
              );
            }

            print('BURST $totalArrivalTime');
            totalBurst += totalArrivalTime;

            dev.log(
                "New process is shorter than existing, saving work ($currentWork) in bar and starting P${count + 1}");
            currentWork = 0;

            if (currentProcess.processQueueNumber != -1) {
              backlog.add(currentProcess);
            }
            currentProcess = processList[count];
          } else {
            dev.log("New process is longer than existing, adding to queue");
            backlog.add(processList[count]);
          }
          count++;
          if (count > processList.length - 1) break;
        }
      }

      if (currentProcess.processQueueNumber == -1 &&
          count >= processList.length) {
        dev.log("Finished SJF Pre Empt");
        break;
      }

      currentProcess.processTime--;
      currentWork++;
      totalArrivalTime++;
      for (var element in backlog) {
        totalWait++;
      }
      dev.log(
          "ProcessQueue#${currentProcess.processQueueNumber + 1} | ${currentProcess.toString()} | currentWork: $currentWork | time: $totalArrivalTime | totalWait: $totalWait | count $count | backlog: $backlog");
    }

    _waitTime = totalWait.toDouble();
    _avgWaitTime = totalWait / (processList.length + 1);

    _burstTime = totalBurst.toDouble();
    _avgBurstTime = totalBurst / (processList.length + 1);

    notifyListeners();
  }
}
