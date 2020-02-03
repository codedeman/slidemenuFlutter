import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slidemenu/authenticate/sign_up.dart';
import 'package:slidemenu/search/search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';


class ListPage extends StatefulWidget{
  @override

  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkGPS();
  }

  var geolocator = Geolocator();



  checkGPS() async {

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());


//      StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
//          (Position position) {
//        print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
//      });


  }



  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
          title: Text('Car'),
          leading: IconButton(icon: Icon(Icons.search),
            iconSize: 20.0,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
            },

        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
            children: const <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: Text('Drawer Header',style: TextStyle(color: Colors.white,fontSize: 24)),
                ),
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text('Messages'),
                ),
            ]

        ),
      ),
      bottomNavigationBar: BottomNavigationBar(

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flight),
              title: Text('May bay'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airport_shuttle),
              title: Text('Car'),
            ),
          ]

      ),
      body: _buildBody(context),

    );
  }
  Widget _buildBody(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(

      stream: Firestore.instance.collection('bandnames').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),

        child: ListTile(
          leading: IconButton(
              color: Colors.red,
              icon: Icon(Icons.directions_bus) ),
          title: Text(record.name),

          subtitle: Text(record.station+"->"+record.destination),

//          Text(record.station+"->"+record.destination),
          trailing: IconButton(icon: Icon(Icons.phone) , onPressed: (){

            _callPhone(record.phone);

//            print(record.phone);
//            _launchURL();
        }, )

//          onTap: () => record.reference.updateData({'votes': FieldValue.increment(1)}),
        ),
      ),
    );
  }






}





class Record {

  final String name;
  final int votes;
  final String phone;
  final String station;
  final String destination;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})

      : assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['phone'] != null),
        assert(map['station'] != null),
//        assert(map['destination'] != null),

        name = map['name'],
        votes = map['votes'],
        phone =  map['phone'],
        station = map['station'],
        destination = map['destination'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes:$phone:$station:$destination>";
}



