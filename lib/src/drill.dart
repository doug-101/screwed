// Screwed, a web app for finding drill and thread data.
// Copyright (C) 2018, Douglas W. Bell
//
// This is free software; you can redistribute it and/or modify it under the
// terms of the GNU General Public License, either Version 2 or any later
// version.  This program is distributed in the hope that it will be useful,
// but WITTHOUT ANY WARRANTY.  See the included LICENSE file for details.

/// Store data for a particular drill size.
class Drill implements Comparable<Drill> {
  final String diaName;
  final double diameter;
  final bool isCommon;
  final bool isMetric;

  Drill(Map<String, dynamic> data, this.isMetric)
      : diaName = data['name'],
        diameter = data['diameter'],
        isCommon = data['common'] ?? true;

  double get inchDia => isMetric ? (diameter / 0.00254).round() / 10000 :
                        diameter;

  double get mmDia => isMetric ? diameter : (diameter * 25400).round() / 1000;

  /// Return the text name including a unit conversion.
  String toString() {
    if (isMetric) {
      return '$diaName [${inchDia.toStringAsFixed(3)} in]';
    } else {
      return '$diaName, ${diameter.toStringAsFixed(4)} '
             '[${mmDia.toStringAsFixed(2)} mm]';
    }
  }

  /// Return an HTML table of drill data.
  String toTable(bool metricFirst, double boldInchDia) {
    var entries = [diaName];
    if (metricFirst) {
      entries.addAll(['${mmDia.toStringAsFixed(3)} mm',
                      '[${inchDia.toStringAsFixed(4)} in]']);
    } else {
      entries.addAll(['${inchDia.toStringAsFixed(4)} in',
                      '[${mmDia.toStringAsFixed(3)} mm]']);
    }
    if (boldInchDia == inchDia) {
      entries = entries.map((entry) => '<b>$entry</b>').toList();
    }
    return '<td>${entries.join('</td><td>')}</td>';
  }

  int compareTo(Drill other) {
    return inchDia.compareTo(other.inchDia);
  }
}
