import 'package:YogaAsana/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import '../util/auth.dart';

class Login extends StatefulWidget {
  // final List<CameraDescription> cameras;

  // const Login({this.cameras});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailInputController = TextEditingController();
  TextEditingController _pwdInputController = TextEditingController();

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (value.length == 0) {
      return 'Email cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length == 0) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.pink,
                    Colors.yellowAccent,
                  ]),
            ),
          ),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: Form(
                key: _loginFormKey,
                child: ListView(
                  children: <Widget>[
                    // Image
                    Container(
                      height: size.height * .36,
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Image(
                        image: AssetImage('assets/images/1.png'),
                      ),
                    ),

                    SizedBox(
                      height: 15.0,
                    ),

                    Center(
                        child: Text("Login",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Signatra",
                                color: Colors.black54))),

                    SizedBox(
                      height: 30,
                    ),

                    // Email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailInputController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // #7449D1
                        ),
                      ),
                      validator: emailValidator,
                    ),

                    SizedBox(
                      height: 32.0,
                    ),

                    // Password
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _pwdInputController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: pwdValidator,
                    ),

                    SizedBox(
                      height: 30.0,
                    ),

                    // Button
                    Center(
                      child: ButtonTheme(
                        minWidth: 150.0,
                        child: FlatButton(
                          onPressed: _login,
                          color: Colors.deepOrange,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    // Register Now link
                    Center(
                      child: FlatButton(
                        color: Colors.transparent,
                        onPressed: _onRegister,
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 12,
                    ),
                    // GestureDetector(
                    //   onTap: () => signInWithGoogle().whenComplete(() {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) {
                    //           return MainScreen(
                    //             // email: user.email,
                    //             // uid: user.uid,
                    //             // displayName: user.displayName,
                    //             // photoUrl: user.photoUrl,
                    //             // cameras: widget.cameras,
                    //           );
                    //         },
                    //       ),
                    //     );
                    //   }),
                    //   child: Container(
                    //     height: 50.0,
                    //     width: 200.0,
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         image: AssetImage(
                    //             'assets/images/google_signin_button.png'),
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(
          // cameras: widget.cameras,
        ),
      ),
    );
  }

  void _login() async {
    Auth auth = Auth();
    try {
      if (_loginFormKey.currentState.validate()) {
        FirebaseUser user = await auth
            .signIn(
          _emailInputController.text,
          _pwdInputController.text,
        )
            .catchError((err) {
          print(err);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Incorrect Email or Password!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                // email: user.email,
                // uid: user.uid,
                // displayName: user.displayName,
                // photoUrl: user.photoUrl,
                // cameras: widget.cameras,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }
}
