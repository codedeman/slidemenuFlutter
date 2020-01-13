//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//class SearchPage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return _SearchState();
//  }
//}
//
//class _SearchState extends State<SearchPage> {
//  String name = "";
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: TextField(
//            onChanged: (val) => initiateSearch(val),
//            decoration: InputDecoration(
//              border: InputBorder.none,
//              hintText: 'Search now'
//            ),
//          ),
//
//        ),
//        body: StreamBuilder<QuerySnapshot>(
//          stream: name != "" && name != null ? Firestore.instance.collection('bandnames').where("name", arrayContains: name).snapshots()
//              :Firestore.instance.collection("bandnames").snapshots(),
//          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
//
//            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
//              switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//               return new Text('Loading...');
//              default:
//                return new ListView(
//                  children: snapshot.data.documents.map((DocumentSnapshot document){
//                    return new ListTile(
//                      title: new Text(document['name']),
//                    );
//                  }).toList(),
//
//                );
//
//               }
//
//          }
//
//        ),
//      ),
//    );
//  }
//
//  void initiateSearch(String val) {
//    setState(() {
//      name = val.toLowerCase().trim();
//    });
//  }
//}
