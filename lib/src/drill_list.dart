import 'package:screwed/src/drill.dart';
import 'package:screwed/data/drills_english.dart' as english_data;
import 'package:screwed/data/drills_metric.dart' as metric_data;

class DrillData {
  List<Drill> drills;

  DrillData(this.drills);

  DrillData.load(bool isMetric) {
    var data = isMetric ? metric_data.data : english_data.data;
    drills = data.map((item) => Drill(item, isMetric)).toList();
  }
}
