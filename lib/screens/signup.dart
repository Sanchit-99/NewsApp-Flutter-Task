import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:newsapp/provider/auth.dart';
import 'package:newsapp/screens/home.dart';
import 'package:newsapp/screens/signin.dart';
import 'package:newsapp/widgets/input_field.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  static String id = 'signup';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var isLoading = false;
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final repassController = TextEditingController();

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

    Future<void> signup() async {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          repassController.text.isEmpty) {
        _showDialog('Fields Can\'t be Empty');
        return;
      }
      if (passwordController.text != repassController.text) {
        _showDialog('Password does not match.');
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .signup(emailController.text, passwordController.text);
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
            height: mq.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
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
                height: mq.height * 0.60,
                width: mq.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Sign Up',
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
                    SizedBox(height: 10),
                    InputField(
                      hint: 'Re-enter Password:',
                      controller: repassController,
                      obscure: true,
                    ),
                    SizedBox(height: 10),
                    isLoading
                        ? CircularProgressIndicator()
                        : TextButton(
                            onPressed: signup,
                            child: Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.only(
                                      left: 30,
                                      right: 30,
                                      top: 10,
                                      bottom: 10)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlue.shade300),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 30.0, right: 15.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                      Text('or Sign Up with'),
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
                        Text('Have an Account? '),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, SignIn.id, (route) => false);
                          },
                          child: Text(
                            'Sign in',
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
        ],
      ),
    );
  }
}
