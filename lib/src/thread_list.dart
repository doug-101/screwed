import 'package:screwed/src/thread.dart';
import 'package:screwed/data/threads_english.dart' as english_data;
import 'package:screwed/data/threads_metric.dart' as metric_data;

class ThreadData {
  List<Thread> threads;

  ThreadData(this.threads);

  ThreadData.load(bool isMetric) {
    if (isMetric) {
      threads = metric_data.data.map((item) => MetricThread(item)).toList();
    } else {
      threads = english_data.data.map((item) => EnglishThread(item)).toList();
    }
  }
}
