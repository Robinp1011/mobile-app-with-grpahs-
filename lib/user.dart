import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class User {
  int  shifta;
  int  shiftb;
  int  shiftc;
  int  wholeday;
  int  totalcrush;
  int  unique;
  DateTime time;
  DocumentReference reference;


  User(int shifta, int  shiftb, int  shiftc, int  wholeday,
      int  totalcrush, DateTime time, int unique) {
    this.shifta = shifta;
    this.shiftb = shiftb;
    this.shiftc = shiftc;
    this.wholeday = wholeday;
    this.totalcrush = totalcrush;
    this.time = time;
    this.unique = unique;
  }


  User.fromMap(Map<String, dynamic> map, {this.reference}) {
    shifta = map["shifta"];
    shiftb = map["shiftb"];
    shiftc = map["shiftc"];
    wholeday = map["wholeday"];
    totalcrush = map["totalcrush"];
    time = map["time"];
    unique = map["unique"];
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'assetcode': "DCM_LONI_17374801",
      'customer': "DCM",
      'shifta': shifta,
      'shiftb': shiftb,
      'shiftc': shiftc,
      'timestamp':time,
      'totalcrush':totalcrush,
      'unique':unique,
      'wholeday':wholeday
    };
  }

}


