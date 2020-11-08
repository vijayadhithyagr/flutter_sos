import 'package:flutter/material.dart';
import 'package:project_login/login.dart';
import 'package:project_login/register.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Locater'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Login',
              ),
              Tab(
                text: 'Register',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Login(),
            Register()
          ],
        ),
      ),
    );
  }
}
