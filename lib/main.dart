import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import './login_screen2.dart';

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
      },
    );
  }
}

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

class LoginForm extends StatefulWidget {
  LoginForm({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginScreen2(
          backgroundColor1: Color(0xFF444152),
          backgroundColor2: Color(0xFF6f6c7d),
          highlightColor: Color(0xfff65aa3),
          foregroundColor: Colors.white,
          context: context),
    );
  }
}

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

// ------------------- Welcome Screen --------------------
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: WelcomeForm(
          title: title,
        ),
      ),
    );
  }
}

class WelcomeForm extends StatefulWidget {
  WelcomeForm({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomeFormState createState() => _WelcomeFormState();
}

class _WelcomeFormState extends State<WelcomeForm> {
  final _name = TextEditingController();
  final _dateEditing = TextEditingController();
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

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
      response =
          _formatResponseToShowInResultScreen(dayHeWantsToKnow, today, "não ");
      yesOrNo = false;
    }
    _showResultScreen(response, yesOrNo);
  }

  void _showResultScreen(String result, bool willWork) {
    Navigator.of(context).pushNamed('/result',
        arguments: {'result': result, "willWork": willWork});
  }

  @override
  Widget build(BuildContext context) {
    // get Args from route
    Map args = ModalRoute.of(context).settings.arguments;

    var bigScreen = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
            child: TextFormField(
                readOnly: true,
                // controller: _name,
                initialValue: args['name'].toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Qual seu nome?',
                  labelText: 'Nome',
                ))),
        Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.work),
              hintText: 'Você está trabalhando hoje?',
              labelText: 'Trabalhando hoje? *',
            ),
            value: _selectedOption != null ? _selectedOption : _options[0],
            validator: (String value) {
              if (value?.isEmpty ?? true) {
                return 'Informe se está ou não trabalhando hoje!';
              }
              return null;
            },
            items: _options
                .map((option) => DropdownMenuItem(
                      child: new Text(option),
                      value: option,
                    ))
                .toList(),
            onChanged: (newValue) => setState(() => _selectedOption = newValue),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.date_range),
                tooltip: "Selecione uma data",
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
              ),
            ),
            visibilityOfDateText
                ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                      child: TextFormField(
                          controller: _dateEditing,
                          enabled: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.date_range),
                            hintText: 'Formato: xx/xx/xxxx',
                            labelText: 'Data que deseja saber *',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Selecione a data no botão acima ou informe com xx/xx/xxxx';
                            }
                            return null;
                          }),
                    ),
                  )
                : new Container(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processando dados...')));
                _verifyIfHeIsGoingToWork();
              }
            },
            child: Text('Verificar'),
          ),
        ),
      ],
    );

    var smallScreen = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
          child: TextFormField(
              // controller: _name,
              readOnly: true,
              initialValue: args['name'].toString(),
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Qual seu nome?',
                labelText: 'Nome',
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.work),
              hintText: 'Você está trabalhando hoje?',
              labelText: 'Trabalhando hoje? *',
            ),
            value: _selectedOption,
            validator: (String value) {
              if (value?.isEmpty ?? true) {
                return 'Informe se está ou não trabalhando hoje!';
              }
              return null;
            },
            items: _options
                .map((option) => DropdownMenuItem(
                      child: new Text(option),
                      value: option,
                    ))
                .toList(),
            onChanged: (newValue) => setState(() => _selectedOption = newValue),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
          child: IconButton(
            icon: Icon(Icons.date_range),
            tooltip: "Selecione uma data",
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
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
            child: visibilityOfDateText
                ? Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
                    child: TextFormField(
                        controller: _dateEditing,
                        enabled: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.date_range),
                          hintText: 'Formato: xx/xx/xxxx',
                          labelText: 'Data que deseja saber *',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Selecione a data no botão acima ou informe com xx/xx/xxxx';
                          }
                          return null;
                        }),
                  )
                : new Container()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processando dados...')));
                _verifyIfHeIsGoingToWork();
              }
            },
            child: Text('Verificar'),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
          key: _formKey,
          child: MediaQuery.of(context).size.width >= 768.0
              ? bigScreen
              : smallScreen),
    );
  }
}
