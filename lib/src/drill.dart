class Drill {
  final String name;
  final double diameter;
  final bool isMetric;

  Drill(Map<String, dynamic> data, this.isMetric)
      : name = data['name'],
        diameter = data['diameter'];
}
