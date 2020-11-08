import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_login/location.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email, _password;
  final facebookLogin = FacebookLogin();
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
              padding: const EdgeInsets.all(14.0),
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
              padding: const EdgeInsets.all(14.0),
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
              onPressed: login,
              child: Text('Login'),
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
            ),
          ),
          Flexible(
            child: OutlineButton(
              child: Text('Google'),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              onPressed: () {
                signInWithGoogle().then((result) {
                  if (result != null) {
                    String name = result.additionalUserInfo.profile['name'];
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Location(name: name);
                        },
                      ),
                    );
                  }
                });
              },
            ),
          ),
          Flexible(
            child: OutlineButton(
                child: Text('Facebook'),
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                onPressed: () {
                  signInFacebook();
                }),
          )
        ],
      ),
    );
  }

  Future<void> login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Location(name: _email.substring(0, _email.indexOf('@')))));
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInFacebook() async {
    // Trigger the sign-in flow
    // final result = await facebookLogin.logInWithReadPermissions(['email']);
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);

    // Once signed in, return the UserCredential
    UserCredential credentials = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    if (credentials != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Location()));
    } else {
      print('error');
    }
  }

  // Future signInFacebook() async {
  //   final result = await facebookLogin.logIn(['email']);

  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final token = result.accessToken.token;
  //       final graphResponse = await http.get(
  //           'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
  //       final profile = jsonDecode(graphResponse.body);
  //       print(profile);
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => Location()));
  //       //   setState(() {
  //       //     userProfile = profile;
  //       //     _isLoggedIn = true;
  //       //   });
  //       break;

  //     case FacebookLoginStatus.cancelledByUser:
  //       setState(() {});
  //       break;
  //     case FacebookLoginStatus.error:
  //       print('error in fb');
  //       break;
  //   }
  // }
}
