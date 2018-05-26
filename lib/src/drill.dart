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

  String toString() {
    if (isMetric) {
      return '$diaName [${inchDia.toStringAsFixed(3)} in]';
    } else {
      return '$diaName, ${diameter.toStringAsFixed(4)} '
             '[${mmDia.toStringAsFixed(2)} mm]';
    }
  }

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
