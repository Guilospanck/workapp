import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import './database_helper.dart';

class LoginScreen2 extends StatelessWidget {
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;
  final AssetImage logo = AssetImage('img/full-bloom.png');
  final BuildContext context;

  final _name = TextEditingController();
  final _pass = TextEditingController();
  final _textToLogo = TextEditingController();

  void setTextToLogo(value) {
    if (value.length != 0)
      _textToLogo.text = value[0].toUpperCase();
    else
      _textToLogo.text = "";
  }

  void insertIntoDatabase() {
    // DatabaseHelper.instance.queryDatabase().then((res) => res).then((res) => {
    //       DatabaseHelper.instance
    //           .deleteEverything()
    //           .then((res) => res)
    //           .then((res) => {DatabaseHelper.instance.queryDatabase()})
    //     });
    DatabaseHelper.instance
        .insert(_name.text, _pass.text)
        .then((res) => {print("Teste: " + res.toString())});
  }

  dynamic verifyUserCredentials() {
    return DatabaseHelper.instance
        .verifyUserCredentials(_name.text, _pass.text);
  }

  void validateUserCredentialsResponse(var response) {
    if (response.length != 0) {
      Navigator.of(context)
          .pushNamed('/welcome', arguments: {'name': _name.text});
    } else {
      print("Not allowed.");
    }
  }

  void logIntoApp() {
    // insertIntoDatabase();
    verifyUserCredentials().then((res) => validateUserCredentialsResponse(res));
  }

  LoginScreen2(
      {Key k,
      this.backgroundColor1,
      this.backgroundColor2,
      this.highlightColor,
      this.foregroundColor,
      this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.centerLeft,
          end: new Alignment(
              1.0, 0.0), // 10% of the width, so there are ten blinds.
          colors: [
            this.backgroundColor1,
            this.backgroundColor2
          ], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
            child: Center(
              child: new Column(
                children: <Widget>[
                  Container(
                    height: 128.0,
                    width: 128.0,
                    child: new CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: this.foregroundColor,
                      radius: 100.0,
                      child: new TextFormField(
                        controller: _textToLogo,
                        decoration: new InputDecoration.collapsed(hintText: ''),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.w100,
                            color: this.foregroundColor),
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: this.foregroundColor,
                        width: 1.0,
                      ),
                      shape: BoxShape.circle,
                      // image: DecorationImage(image: this.logo)
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new TextFormField(
                      controller: _name,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: this.foregroundColor),
                      decoration: new InputDecoration.collapsed(hintText: ''),
                    ),
                  )
                ],
              ),
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: this.foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                  child: Icon(
                    Icons.person,
                    color: this.foregroundColor,
                  ),
                ),
                new Expanded(
                  child: TextFormField(
                    controller: _name,
                    onChanged: (value) => setTextToLogo(value),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: this.foregroundColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // hintText: 'jaiansousa@flutter.com',
                      hintStyle: TextStyle(color: this.foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: this.foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                  child: Icon(
                    Icons.lock_open,
                    color: this.foregroundColor,
                  ),
                ),
                new Expanded(
                  child: TextFormField(
                    controller: _pass,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: this.foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    color: this.highlightColor,
                    onPressed: () => logIntoApp(),
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: this.foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // new Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          //   alignment: Alignment.center,
          //   child: new Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: new FlatButton(
          //           padding: const EdgeInsets.symmetric(
          //               vertical: 20.0, horizontal: 20.0),
          //           color: Colors.transparent,
          //           onPressed: () => {},
          //           child: Text(
          //             "Esqueceu sua senha?",
          //             style: TextStyle(
          //                 color: this.foregroundColor.withOpacity(0.5)),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // new Expanded(
          //   child: Divider(),
          // ),
          // new Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: const EdgeInsets.only(
          //       left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
          //   alignment: Alignment.center,
          //   child: new Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: new FlatButton(
          //           padding: const EdgeInsets.symmetric(
          //               vertical: 20.0, horizontal: 20.0),
          //           color: Colors.transparent,
          //           onPressed: () => {},
          //           child: Text(
          //             "Não tem uma conta? Crie uma.",
          //             style: TextStyle(
          //                 color: this.foregroundColor.withOpacity(0.5)),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
