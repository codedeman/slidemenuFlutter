import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slidemenu/home/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: Form(
        key: _formKey,
          child: Column(
            children: <Widget>[
          TextFormField(
            validator: (input) {
              if (input.isEmpty) {
                return 'Provide an email';
              }
            },
            decoration: InputDecoration(
                labelText: 'Email'
            ),
            onSaved: (input) => _email = input,
          ),
          TextFormField(
            validator: (input) {
              if (input.length < 6) {
                return 'Longer password please';
              }
            },
            decoration: InputDecoration(

                labelText: 'Pass word'
            ),
            onSaved: (input) => _password = input,
            obscureText: true,
          ),
          RaisedButton(

            onPressed: singnIn,
            child: Text('Sign in'),
          )

        ],
      )),
    );
  }

  void singnIn() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage()));

        print("Success");
      } catch (e) {
        print("hahahaha"+e.message);
      }
    }
  }


}

