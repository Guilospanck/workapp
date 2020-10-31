import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class WelcomeForm extends StatefulWidget {
  WelcomeForm({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomeFormState createState() => _WelcomeFormState();
}

class _WelcomeFormState extends State<WelcomeForm> {
  final Color backgroundColor1 = Color(0xFF444152);
  final Color backgroundColor2 = Color(0xFF6f6c7d);
  final Color highlightColor = Color(0xfff65aa3);
  final Color foregroundColor = Colors.white;

  final _name = TextEditingController();
  final _dateEditing = TextEditingController();

  bool showSnackbar = false;

  List<String> _options = ["Sim", "Não"];
  String _selectedOption;
  DateTime whatDayHeWants = DateTime.now();
  bool visibilityOfDateText = false;

  String _transformDateTimeIntoDate(DateTime date) {
    var day = date.day;
    var month = date.month;
    var year = date.year;

    var total = day.toString() + "/" + month.toString() + "/" + year.toString();
    return total;
  }

  void _setDate(DateTime date) {
    setState(() {
      _dateEditing.text = _transformDateTimeIntoDate(date);
      whatDayHeWants = date;
    });
  }

  void _setVisibilityOfDateTextField(bool visibility) {
    setState(() {
      visibilityOfDateText = visibility;
    });
  }

  String _verifyWhichTeamIsByDifference(int difference) {
    var result = "";
    if (difference % 2 == 0) {
      result = "A";
    } else {
      result = "B";
    }
    return result;
  }

  int _getDifferenceOfDatesInDays(DateTime aboveDate) {
    var beginningOfTheYear =
        DateTime(aboveDate.year - 1, DateTime.december, 31);
    var difference = aboveDate.difference(beginningOfTheYear).inDays;

    return difference;
  }

  String _verifyWhichTeamIsHe(DateTime today, String isHeWorkingToday) {
    var difference = _getDifferenceOfDatesInDays(today);
    var teamToday = _verifyWhichTeamIsByDifference(difference); // A or B

    var whatTeamIsHe = "null";
    if (isHeWorkingToday == "Sim") {
      whatTeamIsHe = teamToday;
    } else {
      whatTeamIsHe = teamToday == 'A' ? 'B' : 'A';
    }

    return whatTeamIsHe;
  }

  String _formatResponseToShowInResultScreen(
      DateTime dayHeWantsToKnow, DateTime today, String workingOrNot) {
    var response = "";
    if (dayHeWantsToKnow.isAfter(today)) {
      response =
          _name.text + ", você " + workingOrNot + "irá trabalhar nesse dia.";
    } else if (dayHeWantsToKnow.isAtSameMomentAs(today)) {
      response =
          _name.text + ", você " + workingOrNot + "está trabalhando hoje.";
    } else if (dayHeWantsToKnow.isBefore(today)) {
      response = _name.text + ", você " + workingOrNot + "trabalhou nesse dia.";
    }

    return response;
  }

  void _verifyIfHeIsGoingToWork() {
    if (_dateEditing.text.length != 0) {
      setState(() {
        showSnackbar = false;
      });

      var today = DateTime.now();
      var dayHeWantsToKnow = whatDayHeWants;
      var isHeWorkingToday = _selectedOption;

      var whatTeamIsHe = _verifyWhichTeamIsHe(today, isHeWorkingToday);

      var difference = _getDifferenceOfDatesInDays(dayHeWantsToKnow);
      var teamOfTheDay = _verifyWhichTeamIsByDifference(difference);

      var response = "";
      bool yesOrNo = false;
      if (teamOfTheDay == whatTeamIsHe) {
        response =
            _formatResponseToShowInResultScreen(dayHeWantsToKnow, today, "");
        yesOrNo = true;
      } else {
        response = _formatResponseToShowInResultScreen(
            dayHeWantsToKnow, today, "não ");
        yesOrNo = false;
      }
      _showResultScreen(response, yesOrNo);
    } else {
      setState(() {
        showSnackbar = true;
      });
    }
  }

  void _showResultScreen(String result, bool willWork) {
    Navigator.of(context).pushNamed('/result',
        arguments: {'result': result, "willWork": willWork});
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('Work App'),
          backgroundColor: this.backgroundColor1,
        ),
        body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.centerLeft,
              end: new Alignment(
                  1.0, 0.0), // 10% of the width, so there are ten blinds.
              colors: [
                this.backgroundColor1,
                this.backgroundColor2
              ], // whitish to gray
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 70.0, bottom: 50.0),
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
                            initialValue:
                                args['name'][0].toString().toUpperCase(),
                            decoration:
                                new InputDecoration.collapsed(hintText: ''),
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
                          decoration:
                              new InputDecoration.collapsed(hintText: ''),
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
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Icon(
                        Icons.person,
                        color: this.foregroundColor,
                      ),
                    ),
                    new Expanded(
                      child: TextFormField(
                        readOnly: true,
                        initialValue: args['name'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: this.foregroundColor),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          border: InputBorder.none,
                          labelText: 'Nome',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: this.foregroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
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
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Icon(
                        Icons.work,
                        color: this.foregroundColor,
                      ),
                    ),
                    new Expanded(
                        child: new Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: this.highlightColor,
                      ),
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        style: TextStyle(color: this.foregroundColor),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 15.0, top: 10.0, bottom: 10.0),
                            hintText: 'Você está trabalhando hoje?',
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: 'Trabalhando hoje? *',
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                        value: _selectedOption != null
                            ? _selectedOption
                            : _options[0],
                        validator: (String value) {
                          if (value?.isEmpty ?? true) {
                            return 'Informe se está ou não trabalhando hoje!';
                          }
                          return null;
                        },
                        items: _options
                            .map((option) => DropdownMenuItem(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: new Text(
                                      option,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  value: option,
                                ))
                            .toList(),
                        onChanged: (newValue) =>
                            setState(() => _selectedOption = newValue),
                      ),
                    )),
                  ],
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
                            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0),
                        child: Icon(Icons.date_range,
                            color: this.foregroundColor)),
                    new Expanded(
                        child: FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2018, 1, 1),
                            maxTime: DateTime(2118, 1, 1), onChanged: (date) {
                          _setDate(date);
                          _setVisibilityOfDateTextField(true);
                        }, onConfirm: (date) {
                          _setDate(date);
                          _setVisibilityOfDateTextField(true);
                        }, currentTime: DateTime.now(), locale: LocaleType.pt);
                      },
                      child: TextFormField(
                          controller: _dateEditing,
                          readOnly: true,
                          enabled: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: 'Formato: xx/xx/xxxx',
                              labelText: 'Data que deseja saber *',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Selecione a data no botão acima ou informe com xx/xx/xxxx';
                            }
                            return null;
                          }),
                    )),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        color: this.highlightColor,
                        onPressed: () {
                          if (showSnackbar)
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Preencha todos os campos.')));
                          _verifyIfHeIsGoingToWork();
                        },
                        child: Text(
                          "Verificar",
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
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   // get Args from route
  //   Map args = ModalRoute.of(context).settings.arguments;

  //   var bigScreen = Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Padding(
  //           padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
  //           child: TextFormField(
  //               readOnly: true,
  //               // controller: _name,
  //               initialValue: args['name'].toString(),
  //               decoration: const InputDecoration(
  //                 icon: Icon(Icons.person),
  //                 hintText: 'Qual seu nome?',
  //                 labelText: 'Nome',
  //               ))),
  //       Padding(
  //         padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
  //         child: DropdownButtonFormField(
  //           decoration: const InputDecoration(
  //             icon: Icon(Icons.work),
  //             hintText: 'Você está trabalhando hoje?',
  //             labelText: 'Trabalhando hoje? *',
  //           ),
  //           value: _selectedOption != null ? _selectedOption : _options[0],
  //           validator: (String value) {
  //             if (value?.isEmpty ?? true) {
  //               return 'Informe se está ou não trabalhando hoje!';
  //             }
  //             return null;
  //           },
  //           items: _options
  //               .map((option) => DropdownMenuItem(
  //                     child: new Text(option),
  //                     value: option,
  //                   ))
  //               .toList(),
  //           onChanged: (newValue) => setState(() => _selectedOption = newValue),
  //         ),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Expanded(
  //             child: IconButton(
  //               icon: Icon(Icons.date_range),
  //               tooltip: "Selecione uma data",
  //               onPressed: () {
  //                 DatePicker.showDatePicker(context,
  //                     showTitleActions: true,
  //                     minTime: DateTime(2018, 1, 1),
  //                     maxTime: DateTime(2118, 1, 1), onChanged: (date) {
  //                   _setDate(date);
  //                   _setVisibilityOfDateTextField(true);
  //                 }, onConfirm: (date) {
  //                   _setDate(date);
  //                   _setVisibilityOfDateTextField(true);
  //                 }, currentTime: DateTime.now(), locale: LocaleType.pt);
  //               },
  //             ),
  //           ),
  //           visibilityOfDateText
  //               ? Expanded(
  //                   child: Padding(
  //                     padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
  //                     child: TextFormField(
  //                         controller: _dateEditing,
  //                         enabled: true,
  //                         decoration: const InputDecoration(
  //                           icon: Icon(Icons.date_range),
  //                           hintText: 'Formato: xx/xx/xxxx',
  //                           labelText: 'Data que deseja saber *',
  //                         ),
  //                         validator: (value) {
  //                           if (value.isEmpty) {
  //                             return 'Selecione a data no botão acima ou informe com xx/xx/xxxx';
  //                           }
  //                           return null;
  //                         }),
  //                   ),
  //                 )
  //               : new Container(),
  //         ],
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 16.0),
  //         child: RaisedButton(
  //           onPressed: () {
  //             if (_formKey.currentState.validate()) {
  //               // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processando dados...')));
  //               _verifyIfHeIsGoingToWork();
  //             }
  //           },
  //           child: Text('Verificar'),
  //         ),
  //       ),
  //     ],
  //   );

  //   var smallScreen = Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
  //         child: TextFormField(
  //             // controller: _name,
  //             readOnly: true,
  //             initialValue: args['name'].toString(),
  //             decoration: const InputDecoration(
  //               icon: Icon(Icons.person),
  //               hintText: 'Qual seu nome?',
  //               labelText: 'Nome',
  //             )),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
  //         child: DropdownButtonFormField(
  //           decoration: const InputDecoration(
  //             icon: Icon(Icons.work),
  //             hintText: 'Você está trabalhando hoje?',
  //             labelText: 'Trabalhando hoje? *',
  //           ),
  //           value: _selectedOption,
  //           validator: (String value) {
  //             if (value?.isEmpty ?? true) {
  //               return 'Informe se está ou não trabalhando hoje!';
  //             }
  //             return null;
  //           },
  //           items: _options
  //               .map((option) => DropdownMenuItem(
  //                     child: new Text(option),
  //                     value: option,
  //                   ))
  //               .toList(),
  //           onChanged: (newValue) => setState(() => _selectedOption = newValue),
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
  //         child: IconButton(
  //           icon: Icon(Icons.date_range),
  //           tooltip: "Selecione uma data",
  //           onPressed: () {
  //             DatePicker.showDatePicker(context,
  //                 showTitleActions: true,
  //                 minTime: DateTime(2018, 1, 1),
  //                 maxTime: DateTime(2118, 1, 1), onChanged: (date) {
  //               _setDate(date);
  //               _setVisibilityOfDateTextField(true);
  //             }, onConfirm: (date) {
  //               _setDate(date);
  //               _setVisibilityOfDateTextField(true);
  //             }, currentTime: DateTime.now(), locale: LocaleType.pt);
  //           },
  //         ),
  //       ),
  //       Padding(
  //           padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
  //           child: visibilityOfDateText
  //               ? Padding(
  //                   padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
  //                   child: TextFormField(
  //                       controller: _dateEditing,
  //                       enabled: true,
  //                       decoration: const InputDecoration(
  //                         icon: Icon(Icons.date_range),
  //                         hintText: 'Formato: xx/xx/xxxx',
  //                         labelText: 'Data que deseja saber *',
  //                       ),
  //                       validator: (value) {
  //                         if (value.isEmpty) {
  //                           return 'Selecione a data no botão acima ou informe com xx/xx/xxxx';
  //                         }
  //                         return null;
  //                       }),
  //                 )
  //               : new Container()),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 16.0),
  //         child: RaisedButton(
  //           onPressed: () {
  //             if (_formKey.currentState.validate()) {
  //               // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processando dados...')));
  //               _verifyIfHeIsGoingToWork();
  //             }
  //           },
  //           child: Text('Verificar'),
  //         ),
  //       ),
  //     ],
  //   );

  //   return Scaffold(
  //     appBar: AppBar(title: Text(widget.title) //(widget.title),
  //         ),
  //     body: Form(
  //         key: _formKey,
  //         child: MediaQuery.of(context).size.width >= 768.0
  //             ? bigScreen
  //             : smallScreen),
  //   );
  // }

}
