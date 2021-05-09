import 'package:flutter/material.dart';
import 'package:newsapp/provider/auth.dart';
import 'package:newsapp/screens/home.dart';
import 'package:newsapp/screens/signin.dart';
import 'package:newsapp/screens/signup.dart';
import 'package:newsapp/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'News App',
        home: FutureBuilder(
          future: Provider.of<Auth>(context,listen: true).tryAutoLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Splash();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              if (snapshot.hasData) {
                print(snapshot.data);
                return snapshot.data ? Home() : SignUp();
              }
              print('snapshot');
            }
            return Splash();
          },
        ),
        routes: {
          SignIn.id: (context) => SignIn(),
          SignUp.id: (context) => SignUp(),
          Home.id: (context) => Home(),
        },
    );
  }
}
