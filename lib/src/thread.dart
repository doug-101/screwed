// Screwed, a web app for finding drill and thread data.
// Copyright (C) 2018, Douglas W. Bell
//
// This is free software; you can redistribute it and/or modify it under the
// terms of the GNU General Public License, either Version 2 or any later
// version.  This program is distributed in the hope that it will be useful,
// but WITTHOUT ANY WARRANTY.  See the included LICENSE file for details.

import 'dart:math';
import 'package:screwed/screwed.dart' as drillRef;

/// Base class for English and metric threads.
abstract class Thread {
  final double majorDia;
  double pitch, extMinorDia;
  final bool isCommon;

  Thread(Map<String, dynamic> data)
      : majorDia = data['major_dia'],
        isCommon = data['common'];

  double get inchMajorDia => majorDia;

  double get mmMajorDia => majorDia;

  double get threadHeight => sqrt(3) * pitch / 2;

  double get pitchDiameter => majorDia - threadHeight * 3 / 4;

  double get intMinorDia => majorDia - threadHeight * 5 / 4;

  String toTable(double boldMajorDia);

  String details();
}


/// Store data for an inch-based thread.
class EnglishThread extends Thread {
  final String diaName, series, tapName, closeClear, freeClear;
  final num thdsPerInch;

  EnglishThread(Map<String, dynamic> data)
      : diaName = data['dia_name'],
        thdsPerInch = data['thds_per_in'],
        series = data['series'],
        tapName = data['tap_drill'],
        closeClear = data['close_clear'],
        freeClear = data['free_clear'],
        super(data);

  @override
  double get pitch => 1 / thdsPerInch;

  @override
  double get mmMajorDia => (majorDia * 25400).round() / 1000;

  @override
  double get extMinorDia => intMinorDia - threadHeight / 8;

  /// Return an HTML table with the thread name.
  @override
  String toTable(double boldMajorDia) {
    var entries = ['$diaName - $thdsPerInch', series,
                   majorDia.toStringAsFixed(4),
                   '[${mmMajorDia.toStringAsFixed(3)} mm]'];
    if (boldMajorDia == majorDia) {
      entries = entries.map((entry) => '<b>$entry</b>').toList();
    }
    return '<td class="clickable">${entries.join('</td><td>')}</td>';
  }

  /// Return an HTML table of thread paramters.
  @override
  String details() {
    var output = '<h1>$diaName - $thdsPerInch $series</h1>\n<table>';
    var table = [['Major Diameter:', '', '${majorDia.toStringAsFixed(4)} in',
                  '[${mmMajorDia.toStringAsFixed(3)} mm]']];
    table.add(['Pitch Diameter:', '', '${pitchDiameter.toStringAsFixed(4)} in',
               '[${(pitchDiameter * 25.4).toStringAsFixed(3)} mm]']);
    table.add(['Int. Minor Diameter:', '',
               '${intMinorDia.toStringAsFixed(4)} in',
               '[${(intMinorDia * 25.4).toStringAsFixed(3)} mm]']);
    table.add(['Ext. Minor Diameter:', '',
               '${extMinorDia.toStringAsFixed(4)} in',
               '[${(extMinorDia * 25.4).toStringAsFixed(3)} mm]']);
    if (tapName != null) {
      var tapDrillDia = drillRef.englishDrills.nameMatch(tapName).diameter;
      table.add(['Tap Drill:', tapName, '${tapDrillDia.toStringAsFixed(4)} in',
                 '[${(tapDrillDia * 25.4).toStringAsFixed(3)} mm]']);
    }
    if (closeClear != null) {
      var closeClearDia = drillRef.englishDrills.nameMatch(closeClear).
                          diameter;
      table.add(['Close Clearance Hole:', closeClear,
                 '${closeClearDia.toStringAsFixed(4)} in',
                 '[${(closeClearDia * 25.4).toStringAsFixed(3)} mm]']);
    }
    if (freeClear != null) {
      var freeClearDia = drillRef.englishDrills.nameMatch(freeClear).
                          diameter;
      table.add(['Free Clearance Hole:', freeClear,
                 '${freeClearDia.toStringAsFixed(4)} in',
                 '[${(freeClearDia * 25.4).toStringAsFixed(3)} mm]']);
    }
    for (var row in table) {
      output += '\n<tr><td>${row.join('</td><td>')}</td></tr>';
    }
    output += '</table>';
    return output;
  }
}


/// Store data for a millimeter-based thread.
class MetricThread extends Thread {
  final double pitch, tapDia, clearDia;

  MetricThread(Map<String, dynamic> data)
      : pitch = data['pitch'],
        tapDia = data['tap_drill'],
        clearDia = data['clear_hole'],
        super(data);

  @override
  double get inchMajorDia => (majorDia / 0.00254).round() / 10000;

  @override
  double get extMinorDia => intMinorDia - threadHeight * 0.14434;

  /// Return an HTML table with the thread name.
  @override
  String toTable(double boldMajorDia) {
    var entries = ['M$majorDia x $pitch', isCommon ? 'common' : 'uncommon',
                   '[${inchMajorDia.toStringAsFixed(4)} in]'];
    if (boldMajorDia == majorDia) {
      entries = entries.map((entry) => '<b>$entry</b>').toList();
    }
    return '<td class="clickable">${entries.join('</td><td>')}</td>';
  }

  /// Return an HTML table of thread paramters.
  @override
  String details() {
    var commonText = isCommon ? 'common' : 'uncommon';
    var output = '<h1>M$majorDia x $pitch ($commonText)</h1>\n<table>';
    var table = [['Major Diameter:', '${majorDia.toStringAsFixed(3)} mm',
                  '[${inchMajorDia.toStringAsFixed(4)} in]']];
    table.add(['Pitch Diameter:', '${pitchDiameter.toStringAsFixed(3)} mm',
               '[${(pitchDiameter / 25.4).toStringAsFixed(4)} in]']);
    table.add(['Int. Minor Diameter:', '${intMinorDia.toStringAsFixed(3)} mm',
               '[${(intMinorDia / 25.4).toStringAsFixed(4)} in]']);
    table.add(['Ext. Minor Diameter:', '${extMinorDia.toStringAsFixed(3)} mm',
               '[${(extMinorDia / 25.4).toStringAsFixed(4)} in]']);
    if (tapDia != null) {
      table.add(['Tap Drill:', '${tapDia.toStringAsFixed(3)} mm',
                 '[${(tapDia / 25.4).toStringAsFixed(4)} in]']);
    }
    if (clearDia != null) {
      table.add(['Clearance Hole:', '${clearDia.toStringAsFixed(3)} mm',
                 '[${(clearDia / 25.4).toStringAsFixed(4)} in]']);
    }
    for (var row in table) {
      output += '\n<tr><td>${row.join('</td><td>')}</td></tr>';
    }
    output += '</table>';
    return output;
  }
}
