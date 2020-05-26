import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_color/random_color.dart';
 /* class Sales {
  int saleVal;
  String saleYear;
  String colorVal;
  Sales(this.saleVal,this.saleYear);


  Sales.fromSnapshot(DocumentSnapshot snapshot)
      : saleYear= snapshot.data['defaultTimestamp'].toDate().toString();
      //  saleVal = snapshot.data['tags'][0]['value'] ;
  @override
  String toString() => "Record<$saleVal:$saleYear>";
} */


class ChartData {

  ChartData({this.xValue, this.yValue});
  ChartData.fromSnapshot(DocumentSnapshot snapshot, String tag)
  { xValue = snapshot.data['defaultTimestamp'].toDate();

  for(int i=0;i<snapshot.data['tags'].length;i++) {

    if(snapshot.data['tags'][i]['tag'] == tag){


      yValue = snapshot.data['tags'][i]['value'].toDouble();
      break;

    }  }  }

  DateTime xValue;
  double yValue;

}