import 'package:screwed/data/drills_english.dart' as english_data;
import 'package:screwed/data/drills_metric.dart' as metric_data;

List<Drill> loadDrillData() {
  List<Drill> drills = [];
  for (var item in english_data.data) {
    drills.add(Drill(item));
  }
  return drills;
}

class Drill {
  String name;
  double diameter;

  Drill(Map<String, dynamic> data) {
    name = data['name'];
    diameter = data['diameter'];
  }
}
