import 'package:screwed/screwed.dart' as drillRef;

abstract class Thread {
  final double majorDia;
  final bool isCommon;

  Thread(Map<String, dynamic> data)
      : majorDia = data['major_dia'],
        isCommon = data['common'];

  double get inchMajorDia => majorDia;

  double get mmMajorDia => majorDia;

  String toTable(double boldMajorDia);

  String details();
}


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
  double get mmMajorDia => (majorDia * 25400).round() / 1000;

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

  @override
  String details() {
    var output = '<h1>$diaName - $thdsPerInch $series</h1>\n<table>';
    var table = [['Major Diameter:', '', '${majorDia.toStringAsFixed(4)} in',
                  '[${mmMajorDia.toStringAsFixed(3)} mm]']];
    if (tapName != null) {
      var tapDrillDia = drillRef.englishDrills.nameMatch(tapName).diameter;
      var mmTapDrillDia = (tapDrillDia * 25400).round() / 1000;
      table.add(['Tap Drill:', tapName, '${tapDrillDia.toStringAsFixed(4)} in',
                 '[${mmTapDrillDia.toStringAsFixed(3)} mm]']);
    }
    if (closeClear != null) {
      var closeClearDia = drillRef.englishDrills.nameMatch(closeClear).
                          diameter;
      var mmCloseClearDia = (closeClearDia * 25400).round() / 1000;
      table.add(['Close Clearance Hole:', closeClear,
                 '${closeClearDia.toStringAsFixed(4)} in',
                 '[${mmCloseClearDia.toStringAsFixed(3)} mm]']);
    }
    if (freeClear != null) {
      var freeClearDia = drillRef.englishDrills.nameMatch(freeClear).
                          diameter;
      var mmFreeClearDia = (freeClearDia * 25400).round() / 1000;
      table.add(['Free Clearance Hole:', freeClear,
                 '${freeClearDia.toStringAsFixed(4)} in',
                 '[${mmFreeClearDia.toStringAsFixed(3)} mm]']);
    }
    for (var row in table) {
      output += '\n<tr><td>${row.join('</td><td>')}</td></tr>';
    }
    output += '</table>';
    return output;
  }
}


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
  String toTable(double boldMajorDia) {
    var entries = ['M$majorDia x $pitch', isCommon ? 'common' : 'uncommon',
                   '[${inchMajorDia.toStringAsFixed(4)} in]'];
    if (boldMajorDia == majorDia) {
      entries = entries.map((entry) => '<b>$entry</b>').toList();
    }
    return '<td class="clickable">${entries.join('</td><td>')}</td>';
  }

  @override
  String details() {
    var commonText = isCommon ? 'common' : 'uncommon';
    var output = '<h1>M$majorDia x $pitch ($commonText)</h1>\n<table>';
    var table = [['Major Diameter:', '${majorDia.toStringAsFixed(3)} mm',
                  '[${inchMajorDia.toStringAsFixed(4)} in]']];
    if (tapDia != null) {
      var inchTapDia = (tapDia / 0.00254).round() / 10000;
      table.add(['Tap Drill:', '${tapDia.toStringAsFixed(3)} mm',
                 '[${inchTapDia.toStringAsFixed(4)} in]']);
    }
    if (clearDia != null) {
      var inchClearDia = (clearDia / 0.00254).round() / 10000;
      table.add(['Clearance Hole:', '${clearDia.toStringAsFixed(3)} mm',
                 '[${inchClearDia.toStringAsFixed(4)} in]']);
    }
    for (var row in table) {
      output += '\n<tr><td>${row.join('</td><td>')}</td></tr>';
    }
    output += '</table>';
    return output;
  }
}
