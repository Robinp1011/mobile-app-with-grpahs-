
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartData {

  ChartData({this.xValue, this.yValue});
  ChartData.fromSnapshot(DocumentSnapshot snapshot, String tag)
  { xValue = snapshot.data['timestamp'].toDate();

     if(tag == "forecastValue")
       {
         yValue = snapshot.data['data'][0][tag].toDouble();
       }
     else if(tag == "actualValue")
       {
         if(snapshot.data['data'][0]['actualValue'] ==  null)
           {
             yValue = 0;
           }
         else
         yValue = snapshot.data['data'][0]['actualValue'].toDouble();
       }
     else
       {
         if(snapshot.data['data'][0]['actualValue'] == null)
           {
             yValue = snapshot.data['data'][0]['forecastValue'].toDouble();
           }
         else
           {
             if(snapshot.data['data'][0]['actualValue'].toDouble() > snapshot.data['data'][0]['forecastValue'].toDouble())
               {

                 yValue = snapshot.data['data'][0]['actualValue'].toDouble() - snapshot.data['data'][0]['forecastValue'].toDouble();
               }
             else

               yValue = snapshot.data['data'][0]['forecastValue'].toDouble() - snapshot.data['data'][0]['actualValue'].toDouble();
           }
       }

      }

  DateTime xValue;
  double yValue;

}