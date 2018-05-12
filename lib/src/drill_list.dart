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

  bool get isNotEmpty => drills.isNotEmpty;

  DrillData approxMatch(double inchDia, int deltaCount) {
    var startPos = drills.indexWhere((drill) => inchDia <= drill.inchDia);
    var endPos = drills.lastIndexWhere((drill) => inchDia >= drill.inchDia);
    if (startPos < 0) startPos = endPos + 1;  // if inchDia > all drills.
    startPos -= deltaCount;
    endPos += deltaCount;
    if (startPos < 0) startPos = 0;
    if (endPos >= drills.length) endPos = drills.length - 1;
    if (startPos <= endPos) {
      return DrillData(drills.sublist(startPos, endPos + 1));
    }
    return DrillData([]);
  }

  void combine(DrillData other) {
    drills.addAll(other.drills);
    drills.sort();
  }

  String toString() {
    return drills.join('<br>\n');
  }

  String toTable(bool metricFirst, double boldInchDia) {
    var entries = drills.map((drill) =>
                             drill.toTable(metricFirst, boldInchDia));
    return '<table><tr>${entries.join('</tr>\n<tr>')}</tr></table>';
  }
}
