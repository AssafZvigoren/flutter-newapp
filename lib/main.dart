// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:newapp/FirebaseClient.dart';
import 'package:newapp/LoginForm.dart';
import 'package:newapp/WelcomePage.dart';
import 'package:newapp/sliderMenu.dart';

import 'randomWords.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseClient.initialize();
  runApp(/**Login**/ NavApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Like some things',
        home: RandomWords(),
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.lightBlue[800],
            accentColor: Colors.cyan[800],
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            )));
  }
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login',
      home: Scaffold(
        appBar: AppBar(
          title: Text('login'),
        ),
        body: LoginForm(
          onSubmit: (email, password) {
            return FirebaseClient.login(email, password);
          },
        ),
      ),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[800],
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('App'),
          ),
          // body: WelcomePage(),
        ),
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.lightBlue[800],
            accentColor: Colors.cyan[800],
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            )));
  }
}

class NavApp extends StatefulWidget {
  @override
  _NavAppState createState() => _NavAppState();
}

class _NavAppState extends State<NavApp> {
  NavAppDelegate _routerDelegate = NavAppDelegate();
  NavAppInformationParser _routeInformationParser = NavAppInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App',
        home: Scaffold(
            appBar: AppBar(
              title: Text('App'),
            ),
            body: MaterialApp.router(
              title: 'App',
              routerDelegate: _routerDelegate,
              routeInformationParser: _routeInformationParser,
            ),
            drawer: SliderMenu(
              onHome: () {
                _routerDelegate.appState.displayedPage = NavAppPathOptions.home;
              },
              onLogin: () {
                _routerDelegate.appState.displayedPage =
                    NavAppPathOptions.login;
              },
              onRegister: () {
                _routerDelegate.appState.displayedPage =
                    NavAppPathOptions.register;
              },
            )),
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.lightBlue[800],
            accentColor: Colors.cyan[800],
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            )));
  }
}

enum NavAppPathOptions {
  home,
  login,
  register,
}

class NavAppPath {}

class NavAppState extends ChangeNotifier {
  NavAppPathOptions _displayedPage;

  NavAppState() : _displayedPage = NavAppPathOptions.home;

  NavAppPathOptions get displayedPage => _displayedPage;

  set displayedPage(NavAppPathOptions newPath) {
    _displayedPage = newPath;
    notifyListeners();
  }
}

class NavAppInformationParser extends RouteInformationParser<NavAppPath> {
  @override
  Future<NavAppPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    return NavAppPath();
  }
}

class NavAppDelegate extends RouterDelegate<NavAppPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavAppPath> {
  final GlobalKey<NavigatorState> navigatorKey;

  // NavAppPathOptions displayedPage = NavAppPathOptions.home;

  NavAppState appState = NavAppState();
  NavAppDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(key: ValueKey('WelcomePage'), child: WelcomePage()),
        if (appState.displayedPage == NavAppPathOptions.login)
          MaterialPage(
              key: ValueKey('LoginForm'),
              child: LoginForm(onSubmit: (email, password) {
                return FirebaseClient.login(email, password);
              }))
        else if (appState.displayedPage == NavAppPathOptions.register)
          MaterialPage(
              key: ValueKey('RegisterForm'),
              child: LoginForm(
                onSubmit: (email, password) {
                  return FirebaseClient.register(email, password);
                },
                option: LoginFormOptions.register,
              ))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        appState.displayedPage = NavAppPathOptions.home;

        notifyListeners();
        return true;
      },
    );
  }

  // @override
  // GlobalKey<NavigatorState> get navigatorKey => navigatorKey;

  @override
  Future<void> setNewRoutePath(NavAppPath configuration) async {}
}
