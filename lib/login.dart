import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social_app/Signup.dart';
import 'package:social_app/addpost.dart';
import 'package:social_app/home.dart';

class Login extends StatelessWidget {
  Login({super.key});
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: media.size.height * 0.1 * 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 54.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome here',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'regular',
                      fontSize: media.size.height * 0.1 * 0.20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Kindly login with your email',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'MyFont',
                    fontSize: media.size.height * 0.1 * 0.3),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17),
              child: TextFormField(
                controller: email,
                style: TextStyle(
                    color: Color.fromARGB(255, 200, 187, 187),
                    fontFamily: 'MyFont'),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(236, 17, 17, 36),
                    hintText: ' Email',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 200, 187, 187),
                        fontFamily: 'regular'),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17),
              child: TextFormField(
                controller: pass,
                style: TextStyle(
                    color: Color.fromARGB(255, 200, 187, 187),
                    fontFamily: 'MyFont'),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(236, 17, 17, 36),
                    hintText: ' Password',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 200, 187, 187),
                        fontFamily: 'regular'),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2))),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.05,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                        media.size.height * 0.4, media.size.height * 0.1 * 0.6),
                    backgroundColor: Color.fromARGB(255, 238, 96, 143),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onPressed: () async {
                  if (email.text.isNotEmpty && pass.text.isNotEmpty) {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    UserCredential user = await auth.signInWithEmailAndPassword(
                        email: email.text, password: pass.text);
                    if (user.user != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MyFont',
                      fontSize: media.size.height * 0.1 * 0.3),
                )),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Row(
                children: [
                  Container(
                    height: media.size.height * 0.001,
                    color: Colors.white,
                    width: media.size.height * 0.1 * 1.4,
                  ),
                  Column(
                    children: [
                      Text(
                        'OR',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'MyFont'),
                      ),
                      Text(
                        'Login with',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'regular'),
                      ),
                    ],
                  ),
                  Container(
                    height: media.size.height * 0.001,
                    color: Colors.white,
                    width: media.size.height * 0.1 * 1.4,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: media.size.height * 0.06,
            ),
            Container(
                height: media.size.height * 0.07,
                width: media.size.height * 0.1 * 4,
                decoration: BoxDecoration(
                    color: Color.fromARGB(236, 17, 17, 36),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      'assets/images/google.png',
                      height: media.size.height * 0.03,
                    ),
                    SizedBox(
                      width: media.size.height * 0.05,
                    ),
                    Text(
                      'Continue with',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'regular',
                          fontSize: media.size.height * 0.01 * 1.9),
                    ),
                    Text(
                      ' Google',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MyFont',
                          fontSize: media.size.height * 0.02),
                    )
                  ],
                )),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            Container(
                height: media.size.height * 0.07,
                width: media.size.height * 0.1 * 4,
                decoration: BoxDecoration(
                    color: Color.fromARGB(236, 17, 17, 36),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      'assets/images/facebook.png',
                      height: media.size.height * 0.03,
                    ),
                    SizedBox(
                      width: media.size.height * 0.05,
                    ),
                    Text(
                      'Continue with',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'regular',
                          fontSize: media.size.height * 0.01 * 1.9),
                    ),
                    Text(
                      ' Facebook',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MyFont',
                          fontSize: media.size.height * 0.02),
                    )
                  ],
                )),
            SizedBox(
              height: media.size.height * 0.09,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 65.0),
              child: Row(
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'regular',
                        fontSize: media.size.height * 0.02),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Color.fromARGB(255, 238, 96, 143),
                            fontFamily: 'MyFont',
                            fontSize: media.size.height * 0.02 * 1.2),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
