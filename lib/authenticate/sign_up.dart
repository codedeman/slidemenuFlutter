
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: (val) => initiateSearch(val),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: name != "" && name != null
              ? Firestore.instance
              .collection('brands')
              .where("name", arrayContains: name)
              .snapshots()
              : Firestore.instance.collection("bandnames").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                    return new ListTile(
                      title: new Text(document['name']),
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }
}