// Screwed, a web app for finding drill and thread data.
// Copyright (C) 2018, Douglas W. Bell
//
// This is free software; you can redistribute it and/or modify it under the
// terms of the GNU General Public License, either Version 2 or any later
// version.  This program is distributed in the hope that it will be useful,
// but WITTHOUT ANY WARRANTY.  See the included LICENSE file for details.

import 'package:screwed/src/thread.dart';
import 'package:screwed/data/threads_english.dart' as english_data;
import 'package:screwed/data/threads_metric.dart' as metric_data;

///  Store a searchable list of thread data.
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

  int get length => threads.length;

  /// Return a [ThreadData] instance with sizes near the searched diameter.
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

  /// Return a [ThreadData] instance with matching diameters.
  ThreadData diaNameMatch(String name, bool isCommonOnly) {
    if (isCommonOnly) {
      var commonThreads = threads.where((thread) => thread.isCommon).toList();
      return ThreadData(commonThreads, isMetric).diaNameMatch(name, false);
    }
    if (isMetric && name.startsWith('m')) {
      name = name.substring(1);
      var dia = double.tryParse(name);
      if (dia != null) {
        return ThreadData(threads.where((thread) {
          return thread.majorDia == dia;
        }).toList(), true);
      }
    } else if (!isMetric && name.startsWith('#')) {
      return ThreadData(threads.where((thread) {
        EnglishThread englishThread = thread;
        return englishThread.diaName == name;
      }).toList(), true);
    }
    return ThreadData([], isMetric);
  }

  /// Return a [Thread] that matches the full name.
  Thread nameMatch(String name) {
    if (isMetric) {
      if (name.startsWith('m')) name = name.substring(1);
      var data = name.split('x');
      var dia = double.tryParse(data[0].trim());
      var pitch = double.tryParse(data[1].trim());
      if (dia != null && pitch != null) {
        for (MetricThread thread in threads) {
          if (thread.majorDia == dia && thread.pitch == pitch) {
            return thread;
          }
        }
      }
    } else {
      var data = name.split('-');
      if (data.length > 2) {
        data[0] = '${data[0]}-${data[1]}';
        data[1] = data[2];
      }
      var diaName = data[0].trim();
      if (int.tryParse(diaName) != null) diaName = '#' + diaName;
      if (!diaName.startsWith('#') && !diaName.endsWith('in')) {
        diaName = diaName + ' in';
      }
      var fractionData = diaName.split(RegExp(r'\s+'));
      if (fractionData.length == 3) {
        diaName = '${fractionData[0]}-${fractionData[1]} ${fractionData[2]}';
      }
      var thdsPerInch = double.tryParse(data[1].trim());
      if (thdsPerInch == null) return null;
      for (EnglishThread thread in threads) {
        if (thread.diaName == diaName && thread.thdsPerInch == thdsPerInch) {
          return thread;
        }
      }
      diaName = data[0].trim();
      if (diaName.endsWith('in')) {
        diaName = diaName.substring(0, diaName.length - 2).trim();
      } else if (diaName.endsWith('"')) {
        diaName = diaName.substring(0, diaName.length - 1).trim();
      }
      var dia = double.tryParse(diaName);
      if (dia != null) {
        for (EnglishThread thread in threads) {
          if (thread.majorDia == dia && thread.thdsPerInch == thdsPerInch) {
            return thread;
          }
        }
      }
    }
    return null;
  }

  /// Return an HTML table of all thread data.
  String toTable(double boldMajorDia) {
    var entries = threads.map((thread) => thread.toTable(boldMajorDia));
    return '<table><tr>${entries.join('</tr>\n<tr>')}</tr></table>';
  }
}
