import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthenticationService.dart';

class EmailPasswordSignInPage extends StatefulWidget {
  @override
  _EmailPasswordSignInPageState createState() =>
      _EmailPasswordSignInPageState();
}

class _EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // make use of get current user from context.read<AuthenticationService>()
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Column(children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Password",
          ),
        ),
        RaisedButton(
          onPressed: () {
            context.read<AuthenticationService>().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
            Navigator.pop(context);
          },
          child: Text("Sign in"),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ]),
    );
  }
}
