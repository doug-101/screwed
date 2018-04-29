import 'package:screwed/data/threads_english.dart' as english_data;
// import 'package:screwed/data/threads_metric.dart' as metric_data;

List<Thread> loadThreadData() {
  List<Thread> threads = [];
  for (var item in english_data.data) {
    threads.add(Thread(item));
  }
  return threads;
}

class Thread {
  String diaName, series;
  double majorDia;
  num thdsPerInch;

  Thread(Map<String, dynamic> data) {
    diaName = data['dia_name'];
    majorDia = data['major_dia'];
    thdsPerInch = data['thds_per_inch'];
    series = data['series'];
  }
}
