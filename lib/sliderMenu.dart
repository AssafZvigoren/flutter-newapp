import 'package:flutter/material.dart';

class SliderMenu extends StatelessWidget {
  SliderMenu({this.onHome, this.onLogin, this.onRegister});
  final VoidCallback? onHome;
  final VoidCallback? onLogin;
  final VoidCallback? onRegister;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/me.jpg'),
            radius: 50,
          )),
          ListTile(
            title: Text('Home'),
            onTap: () {
              onHome?.call();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Login'),
            onTap: () {
              onLogin?.call();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Register'),
            onTap: () {
              onRegister?.call();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
