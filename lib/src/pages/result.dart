import 'package:cpu_scheduling/src/providers/algo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/process_table_provider.dart';

class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key});

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(algoProvider).FCFS();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(algoProvider);
    var processProvider = ref.watch(processTableProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPU Scheduling'),
        bottom: TabBar(
          controller: _controller,
          onTap: (value) {
            if (value == 0) {
              ref.read(algoProvider).FCFS();
            } else if (value == 1) {
              ref.read(algoProvider).SJFNonEmptive();
            } else if (value == 2) {
              ref.read(algoProvider).SJFPreEmptive();
            }
            print(value);
          },
          tabs: const [
            Tab(text: 'FCFS'),
            Tab(text: 'SJF NON'),
            Tab(text: 'SJF PRE'),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Total Wait: ${provider.waitTime.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Average Wait: ${provider.avgWaitTime.toStringAsFixed(2)}',
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Total Burst: ${provider.burstTime.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Average Burst: ${provider.avgBurstTime.toStringAsFixed(2)}',
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: Row(
                children: provider.progressBar,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text('Process ID'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text('Arrival Time'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text('Process Time'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: processProvider.processList.length,
                    padding: const EdgeInsets.only(bottom: 100),
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text('P${index + 1}'),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(processProvider
                                  .processList[index].arrivalTime
                                  .toString()),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(processProvider
                                  .processList[index].processTime
                                  .toInt()
                                  .toString()),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
