import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_login/location.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _email, _password;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Image(
              image: AssetImage('images/flutter.png'),
              width: 100.0,
              height: 100.0,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                onChanged: (value) => _email = value,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                onChanged: (value) => _password = value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Flexible(
            child: RaisedButton(
              onPressed: register,
              child: Text('Register'),
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      if (userCredential != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Location(name: _email.substring(0, _email.indexOf('@')))));
      } else {
        print('values not read');
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
