abstract class Thread {
  final double majorDia;
  final bool isCommon;

  Thread(Map<String, dynamic> data)
      : majorDia = data['major_dia'],
        isCommon = data['common'];

  double get inchMajorDia => majorDia;

  double get mmMajorDia => majorDia;

  String toTable(double boldMajorDia);
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
    return '<td>${entries.join('</td><td>')}</td>';
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
    return '<td>${entries.join('</td><td>')}</td>';
  }
}
