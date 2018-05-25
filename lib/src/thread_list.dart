import 'package:screwed/src/thread.dart';
import 'package:screwed/data/threads_english.dart' as english_data;
import 'package:screwed/data/threads_metric.dart' as metric_data;

class ThreadData {
  List<Thread> threads;
  bool isMetric;

  ThreadData(this.threads, this.isMetric);

  ThreadData.load(bool isMetric) {
    this.isMetric = isMetric;
    if (isMetric) {
      threads = metric_data.data.map((item) => MetricThread(item)).toList();
    } else {
      threads = english_data.data.map((item) => EnglishThread(item)).toList();
    }
  }

  bool get isNotEmpty => threads.isNotEmpty;

  ThreadData approxMatch(double majorDia, bool isCommonOnly) {
    if (isCommonOnly) {
      var commonThreads = threads.where((thread) => thread.isCommon).toList();
      return ThreadData(commonThreads, isMetric).approxMatch(majorDia, false);
    }
    var startPos = threads.indexWhere((thread) => majorDia <= thread.majorDia);
    var endPos = threads.lastIndexWhere((thread) =>
                                        majorDia >= thread.majorDia);
    if (startPos < 0) startPos = endPos + 1;  // if majorDia > all threads
    if (startPos > 0) {
      double lowerDia = threads[startPos - 1].majorDia;
      while (startPos > 0 && threads[startPos - 1].majorDia == lowerDia) {
        startPos--;
      }
    }
    if (endPos + 1 < threads.length) {
      double upperDia = threads[endPos + 1].majorDia;
      while (endPos + 1 < threads.length &&
             threads[endPos + 1].majorDia == upperDia) {
        endPos++;
      }
    }
    return ThreadData(threads.sublist(startPos, endPos + 1), isMetric);
  }

  Thread nameMatch(String name) {
    if (isMetric) {
      var data = name.substring(1).split('x');
      var dia = double.parse(data[0].trim());
      var pitch = double.parse(data[1].trim());
      for (MetricThread thread in threads) {
        if (thread.majorDia == dia && thread.pitch == pitch) {
          return thread;
        }
      }
    } else {
      var data = name.split(' - ');
      var diaName = data[0].trim();
      var thdsPerInch = double.parse(data[1].trim());
      for (EnglishThread thread in threads) {
        if (thread.diaName == diaName && thread.thdsPerInch == thdsPerInch) {
          return thread;
        }
      }
    }
  }

  String toTable(double boldMajorDia) {
    var entries = threads.map((thread) => thread.toTable(boldMajorDia));
    return '<table><tr>${entries.join('</tr>\n<tr>')}</tr></table>';
  }
}
