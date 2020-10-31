import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './login_screen2.dart';
import './welcome_screen.dart';
import './result_screen.dart';
import './register_screen.dart';

void main() => runApp(WorkApp());

class WorkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove debug banner
      title: 'Work App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => LoginScreen(title: 'Que dia eu trabalho?'),
        '/welcome': (context) => WelcomeScreen(title: 'Que dia eu trabalho?'),
        '/result': (context) => ResultScreen(title: 'Que dia eu trabalho?'),
        '/register': (context) => RegisterScreen(title: 'Que dia eu trabalho?'),
      },
    );
  }
}

// ------------------ Login Screen ----------------------
class LoginScreen extends StatelessWidget {
  LoginScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: LoginForm(
          title: title,
        ),
      ),
    );
  }
}

// ------------------ Register Screen -------------------
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: RegisterForm(
          title: title,
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RegisterScreenComponent(
          backgroundColor1: Color(0xFF444152),
          backgroundColor2: Color(0xFF6f6c7d),
          highlightColor: Color(0xfff65aa3),
          foregroundColor: Colors.white,
          context: context),
    );
  }
}

// ------------------ Result Screen ---------------------
class ResultScreen extends StatelessWidget {
  ResultScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: ResultForm(
          title: title,
        ),
      ),
    );
  }
}

class ResultForm extends StatefulWidget {
  ResultForm({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ResultFormState createState() => _ResultFormState();
}

class _ResultFormState extends State<ResultForm> {
  @override
  Widget build(BuildContext context) {
    // get Args from route
    Map args = ModalRoute.of(context).settings.arguments;

    return Container(
      child: ResultScreenComponent(args: args, widget: widget),
    );
  }
}

// ------------------- Welcome Screen --------------------
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: WelcomeForm(title: title),
      ),
    );
  }
}
