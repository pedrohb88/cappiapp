import 'package:cappiapp/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cappiapp/screens/register_screen/components/my_page_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import 'package:cappiapp/models/json_request.dart';
import 'package:cappiapp/models/user.dart';

final greenColor = Color(0xFF008600);

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _phase;
  bool _alreadyRegistered;
  bool _loading = false;

  String _email;
  String _verificationCode;
  String _name;

  final _formKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  double inputHeight = 45.0;

  @override
  void initState() {
    _phase = 'waitingMail';
  }

  showCustomDialog(msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _buildEmailForm() {
    return Column(
        children: <Widget>[
      Text(
        'Cappi',
        style: TextStyle(
            color: greenColor, fontWeight: FontWeight.bold, fontSize: 32.0),
      ),
      Text(
        'Digite seu email e use grátis',
        style: TextStyle(
          color: greenColor,
        ),
      ),
      Column(
          children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: marginBottom,
                height: inputHeight,
                width: double.infinity,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greenColor),
                      ),
                      hintText: 'exemplo@email.com',
                      labelText: 'Email',
                      labelStyle: TextStyle(color: greenColor)),
                  validator: (value) {
                    value = value.trim();
                    if (EmailValidator.validate(value)) {
                      setState(() {
                        inputHeight = 45.0;
                        _email = value;
                      });

                      sendVerificationCode(value, context);

                      return null;
                    }

                    setState(() {
                      inputHeight = 70.0;
                    });
                    return 'Email inválido';
                  },
                ),
              ),
              Container(
                height: 40.0,
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  textColor: Colors.white,
                  onPressed: () {
                    print('continuar pressed');

                    if (_formKey.currentState.validate()) {}
                  },
                  color: greenColor,
                  child: Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
        /*Container(
          height: 40.0,
          width: double.infinity,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            textColor: Colors.white,
            child: Text('Entrar com o Google'),
            onPressed: () {
              print('google pressed');
            },
            color: Color(0xFF276E96),
          ),
        ),*/
      ].map((w) {
        return Container(
          child: w,
          margin: EdgeInsets.only(top: 16.0),
        );
      }).toList()),
    ].map((w) {
      return Container(
        child: w,
        margin: EdgeInsets.only(top: 16.0),
      );
    }).toList());
  }

  _buildCodeForm() {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
            children: <Widget>[
          Text(
            'Enviamos um código de verificação para $_email. É só inserir ele aqui pra continuar.',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Column(
              children: [
            Form(
              child: Column(
                children: [
                  Container(
                    margin: marginBottom,
                    height: inputHeight,
                    width: double.infinity,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _verificationCode = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: greenColor),
                        ),
                        hintText: 'XXXX',
                        labelText: 'Código',
                        labelStyle: TextStyle(color: greenColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: double.infinity,
                    child: Consumer<User>(
                      builder: (context, user, child) {
                        print('user consumer: $user');

                        return RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          textColor: Colors.white,
                          onPressed: () {
                            if (_alreadyRegistered) {
                              logUserIn(context, user);
                            } else {
                              setState(() {
                                _phase = 'waitingName';
                              });
                            }
                          },
                          color: greenColor,
                          child: Text('Continuar'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ].map((w) {
            return Container(
              child: w,
              margin: EdgeInsets.only(top: 16.0),
            );
          }).toList()),
        ].map((w) {
          return Container(
            child: w,
            margin: EdgeInsets.only(top: 16.0),
          );
        }).toList()));
  }

  _buildNameForm() {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
            children: <Widget>[
          Text(
            'Como você se chama?',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Column(
              children: [
            Form(
              key: _nameFormKey,
              child: Column(
                children: [
                  Container(
                    margin: marginBottom,
                    height: inputHeight,
                    width: double.infinity,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: greenColor),
                        ),
                        hintText: 'Fulano de tal',
                        labelText: 'Nome',
                        labelStyle: TextStyle(color: greenColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: double.infinity,
                    child: Consumer<User>(
                      builder: (context, user, child) {
                        return RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          textColor: Colors.white,
                          onPressed: () {
                            registerUser(user);
                          },
                          color: greenColor,
                          child: Text('Continuar'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ].map((w) {
            return Container(
              child: w,
              margin: EdgeInsets.only(top: 16.0),
            );
          }).toList()),
        ].map((w) {
          return Container(
            child: w,
            margin: EdgeInsets.only(top: 16.0),
          );
        }).toList()));
  }

  sendVerificationCode(email, context) async {
    setState(() {
      _loading = true;
    });

    final result =
        await JsonRequest().get(route: '/user/verification_code/$email');

    setState(() {
      _loading = false;
    });

    final body = result['body'];
    if (body['success']) {
      setState(() {
        _phase = 'waitingCode';
        _alreadyRegistered = body['alreadyRegistered'];
      });
    } else {
      showCustomDialog(
          'Falha ao enviar código de autenticação. Tem certeza que seu email é um email válido?');
    }
  }

  logUserIn(context, user) async {
    setState(() {
      _loading = true;
    });

    final result = await JsonRequest().post(
        route: '/users/login',
        body: {"email": _email, "verificationCode": _verificationCode});

    if (result == null) {
      setState(() {
        _loading = false;
      });
      showCustomDialog('Código inválido.');
    } else {
      print(result);

      final storage = new FlutterSecureStorage();

      await storage.write(
          key: 'auth-token', value: result['headers']['x-auth']);

      setState(() {
        _phase = 'logged';
        _loading = false;
      });

      final body = result['body'];

      user.update(body['name'], body['email'], body['totalBalance'].toDouble());
    }
  }

  registerUser(user) async {
    setState(() {
      _loading = true;
    });

    var result = await JsonRequest().post(route: '/user', body: {
      "name": _name,
      "email": _email,
      "verificationCode": _verificationCode,
    });

    if (result == null) {
      setState(() {
        _loading = false;
      });
      print('result do cadastro deu null');
      showCustomDialog('Falha ao realizar cadastro');
    } else {
      print('cadastro salvando token na storage');
      print(
          'token sendo registrado no storage: ${result['headers']['x-auth']}');
      final storage = new FlutterSecureStorage();

      await storage.write(
          key: 'auth-token', value: result['headers']['x-auth']);

      setState(() {
        _phase = 'logged';
        _loading = false;
      });

      final body = result['body']['data'];
      user.update(body['name'], body['email'], body['totalBalance'].toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentWidget = _buildEmailForm();

    print(_phase);
    print(_alreadyRegistered);

    if (_phase == 'waitingCode')
      currentWidget = _buildCodeForm();
    else if (_phase == 'waitingName') currentWidget = _buildNameForm();

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SafeArea(child:MyPageView()),
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: currentWidget,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withAlpha(100),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),),
    );
  }
}
