import 'package:flutter/material.dart';

class ResultScreenComponent extends StatelessWidget {
  final Map args;
  final widget;

  ResultScreenComponent({this.args, this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: args != null
            ? ListView(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            child: args['willWork']
                                ? (MediaQuery.of(context).size.width >= 768.0
                                    ? Image.asset('img/trabalhar.jpeg',
                                        height: 600, fit: BoxFit.fill)
                                    : Image.asset('img/trabalhar.jpeg',
                                        height: 400, fit: BoxFit.fill))
                                : (MediaQuery.of(context).size.width >= 768.0
                                    ? Image.asset('img/folga.jpeg',
                                        height: 600, fit: BoxFit.fill)
                                    : Image.asset('img/folga.jpeg',
                                        height: 400, fit: BoxFit.fill)),
                          ),
                          ListTile(
                            title: Text(args['result']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ])
            : new Container());
  }
}
