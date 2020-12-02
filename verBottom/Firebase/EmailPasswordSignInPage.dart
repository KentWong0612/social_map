import 'package:flushbar/flushbar.dart';
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
    Flushbar flush;
    // make use of get current user from context.read<AuthenticationService>()
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Column(children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
        ),
        RaisedButton(
          onPressed: () async {
            final signInState =
                await context.read<AuthenticationService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
            Navigator.pop(context);
            print(' signIn Test = $signInState');
            if (await signInState != 'signed in') {
              flush = await Flushbar<bool>(
                flushbarPosition: FlushbarPosition.TOP,
                duration: Duration(seconds: 3),
                title: 'Log in fail',
                message:
                    'Please try again. If problem exists, please contact test@gmail.com',
                icon: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              )
                ..show(context);
            } else {
              flush = await Flushbar<bool>(
                flushbarPosition: FlushbarPosition.TOP,
                duration: Duration(seconds: 3),
                title: 'Logged in',
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                ),
              )
                ..show(context);
            }
          },
          child: Text('Sign in'),
        ),
      ]),
    );
  }
}
