// Screwed, a web app for finding drill and thread data.
// Copyright (C) 2018, Douglas W. Bell
//
// This is free software; you can redistribute it and/or modify it under the
// terms of the GNU General Public License, either Version 2 or any later
// version.  This program is distributed in the hope that it will be useful,
// but WITTHOUT ANY WARRANTY.  See the included LICENSE file for details.

import 'package:screwed/src/drill.dart';
import 'package:screwed/data/drills_english.dart' as english_data;
import 'package:screwed/data/drills_metric.dart' as metric_data;

/// Store a searchable list of drill data.
class DrillData {
  List<Drill> drills;

  DrillData(this.drills);

  DrillData.load(bool isMetric) {
    var data = isMetric ? metric_data.data : english_data.data;
    drills = data.map((item) => Drill(item, isMetric)).toList();
  }

  bool get isNotEmpty => drills.isNotEmpty;

  /// Return a [DrillData] instance with sizes near the searched diameter.
  DrillData approxMatch(double inchDia, int deltaCount, bool isCommonOnly) {
    if (isCommonOnly) {
      var commonDrills = drills.where((drill) => drill.isCommon).toList();
      return DrillData(commonDrills).approxMatch(inchDia, deltaCount, false);
    }
    var startPos = drills.indexWhere((drill) => inchDia <= drill.inchDia);
    var endPos = drills.lastIndexWhere((drill) => inchDia >= drill.inchDia);
    if (startPos < 0) {
      startPos = endPos - deltaCount;
    } else if (endPos < 0) {
      endPos = deltaCount;
    } else {
      startPos -= deltaCount;
      endPos += deltaCount;
    }
    if (startPos < 0) startPos = 0;
    if (endPos >= drills.length) endPos = drills.length - 1;
    return DrillData(drills.sublist(startPos, endPos + 1));
  }

  /// Return a [Drill] that matches the name.
  Drill nameMatch(String name) {
    for (Drill drill in drills) {
      if (name == drill.diaName) return drill;
    }
    return null;
  }

  /// Combine this with another instance and sort them by size.
  void combine(DrillData other) {
    drills.addAll(other.drills);
    drills.sort();
  }

  String toString() {
    return drills.join('<br>\n');
  }

  /// Return an HTML table of all drill data.
  String toTable(bool metricFirst, double boldInchDia) {
    var entries = drills.map((drill) =>
                             drill.toTable(metricFirst, boldInchDia));
    return '<table><tr>${entries.join('</tr>\n<tr>')}</tr></table>';
  }
}
