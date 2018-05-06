abstract class Thread {
  final double majorDia;
  final bool isCommon;

  Thread(Map<String, dynamic> data)
      : majorDia = data['major_dia'],
        isCommon = data['common'];
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
}


class MetricThread extends Thread {
  final double pitch, tapDia, clearDia;

  MetricThread(Map<String, dynamic> data)
      : pitch = data['pitch'],
        tapDia = data['tap_drill'],
        clearDia = data['clear_hole'],
        super(data);
}
