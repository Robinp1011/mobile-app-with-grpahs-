
import 'package:cloud_firestore/cloud_firestore.dart';
class ChartData {

  ChartData({this.xValue, this.yValue});
  ChartData.fromSnapshot(DocumentSnapshot snapshot)
  { xValue = snapshot.data['timestamp'].toDate();
    yValue = snapshot.data['consumption'].toDouble();
      }

  DateTime xValue;
  double yValue;

}