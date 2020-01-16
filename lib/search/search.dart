import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slidemenu/search/searchservice.dart';


class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchState();
  }
}

class _SearchState extends State<SearchPage> {

  var queryResultSet = [];
  var tempSearchStore = [];
  final myController = TextEditingController();


  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }


    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {

      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

  }







  @override
  Widget build(BuildContext context) {
    @override
    initState() {
      super.initState();
    }



    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: myController,
            onChanged: (val) => initiateSearch(val),
            decoration: InputDecoration(

              prefixIcon: IconButton(
                color: Colors.white,
                icon: Icon(Icons.search),
                iconSize: 20.0,
                onPressed: (){
//                  print("vl"+val)
                  Navigator.of(context).pop();
                },
              ),
              border: InputBorder.none,
              hintText: 'Search by name'
            ),
          ),

        ),

        body:  StreamBuilder<QuerySnapshot>(
          stream: tempSearchStore.isEmpty ? Firestore.instance.collection('bandnames').where("searchKey", arrayContains: tempSearchStore).snapshots()
              :Firestore.instance.collection("bandnames").snapshots(),

          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(
                  child: Text("Loading....."),
                );
              default:
                return new ListView(
                  children: tempSearchStore.map((element) {
                    return buildResultCard(element);
                  }).toList(),
                );
            }
          }
          ),
      ),
    );
  }


}


Widget buildResultCard(data) {
//  if (data.hashCode == null) {
//    return Text("Loading...");
//  } else {
    return ListTile(
      title: Text(data['name']),
    );
//  }
}
