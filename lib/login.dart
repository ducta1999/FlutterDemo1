import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
              child: Stack(children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
                            child: Image.network(
                              "https://login.mangoforsalon.com/Content/logo/mangoforsalon.png",
                              width: MediaQuery.of(context).size.width * 0.5,
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 68, 0, 0),
                            child: const Text("WELCOME BACK!",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26,
                                    fontFamily: "Roboto",
                                    letterSpacing: 1))),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                          child: const TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFA7A7A7))),
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Color(0xFFA7A7A7),
                                    letterSpacing: 0.68,
                                    fontWeight: FontWeight.w500),
                                hintText: "Email or Phone number",
                                fillColor: Colors.white),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: TextField(
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    )),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFA7A7A7))),
                                filled: true,
                                hintStyle: const TextStyle(
                                    color: Color(0xFFA7A7A7),
                                    letterSpacing: 0.68,
                                    fontWeight: FontWeight.w500),
                                hintText: "Password",
                                fillColor: Colors.white),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Row(children: const [
                              Text("Forgot Your Password?",
                                  style: TextStyle(
                                    color: Color(0xFF505050),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ))
                            ])),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: const Color(0xFF8a60af),
                                  onSurface: Colors.grey,
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 24,
                                      48)),
                              onPressed: () {},
                              child: const Text('Login'),
                            )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: const Color(0xFF8a60af),
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 24,
                                      48)),
                              onPressed: () {},
                              child: const Text('Create New Account'),
                            ))
                      ],
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("© 2022 MANGO POWERED BY ",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF595B60))),
                        SvgPicture.network(
                            'https://enrichco.us/wp-content/uploads/2021/12/logo.svg',
                            semanticsLabel: 'enrich',
                            height: 18)
                      ]),
                )
              ])),
        ));
  }
}
