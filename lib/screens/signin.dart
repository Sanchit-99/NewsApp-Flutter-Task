import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:newsapp/provider/auth.dart';
import 'package:newsapp/screens/home.dart';
import 'package:newsapp/screens/signup.dart';
import 'package:newsapp/widgets/input_field.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  static String id = 'signin';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    void _showDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occured!'),
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'))
          ],
        ),
      );
    }

    Future<void> signin() async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        _showDialog('Fields Can\'t be Empty');
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .signin(emailController.text, passwordController.text);
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
      } on HttpException catch (error) {
        _showDialog(error.message);
      } catch (error) {
        _showDialog(error.toString());
      }
      setState(() {
        isLoading = false;
      });
    }

    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          // Max Size
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),

          Positioned(
            bottom: 0,
            child: Opacity(
              opacity: 0.85,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                  color: Colors.white,
                ),
                height: mq.height * 0.6,
                width: mq.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      InputField(
                        hint: 'Email:',
                        controller: emailController,
                        obscure: false,
                      ),
                      SizedBox(height: 10),
                      InputField(
                        hint: 'Password:',
                        controller: passwordController,
                        obscure: true,
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      isLoading
                          ? CircularProgressIndicator()
                          : TextButton(
                              onPressed: signin,
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.only(
                                        left: 35,
                                        right: 35,
                                        top: 12,
                                        bottom: 12)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor('#4abffe')),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 30.0, right: 15.0),
                              child: Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                        Text('or Sign In with'),
                        Expanded(
                          child: new Container(
                              margin:
                                  const EdgeInsets.only(left: 15.0, right: 30),
                              child: Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/images/fb.png',
                            height: 40,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t Have an Account? '),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, SignUp.id, (route) => false);
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(color: Colors.yellow.shade800),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 40,
            top: 100,
            child: Container(
              child: Text(
                'Welcome!!',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          )
        ],
      ),
    );
  }
}
