class Drill {
  final String diaName;
  final double diameter;
  final bool isMetric;

  Drill(Map<String, dynamic> data, this.isMetric)
      : diaName = data['name'],
        diameter = data['diameter'];

  String toString() {
    if (isMetric) {
      return '$diaName [${(diameter / 25.4).toStringAsFixed(3)} in]';
    } else {
      return '$diaName, ${diameter.toStringAsFixed(4)} '
             '[${(diameter * 25.4).toStringAsFixed(2)} mm]';
    }
  }
}
