import 'package:cappiapp/components/custom_dialog.dart';
import 'package:cappiapp/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cappiapp/screens/register_screen/my_page_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import 'package:cappiapp/models/cappi_api.dart';
import 'package:cappiapp/models/user.dart';
import 'package:cappiapp/components/loader.dart';

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
    super.initState();

    _phase = 'waitingMail';
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
                        _loading = true;
                      });

                      CappiApi().sendVerificationCode(value).then((result) {
                        setState(() {
                          _loading = false;
                        });

                        if (result['success']) {
                          setState(() {
                            _phase = 'waitingCode';
                            _alreadyRegistered = result['alreadyRegistered'];
                          });
                        } else {
                          CustomDialog(
                              msg:
                                  'Falha ao enviar código de autenticação. Tem certeza que seu email é um email válido?')
                            ..show(context);
                        }
                        return null;
                      });
                    } else {
                      setState(() {
                        inputHeight = 70.0;
                      });
                      return 'Email inválido';
                    }
                  },
                ),
              ),
              Container(
                margin: marginBottom,
                height: 40.0,
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}
                  },
                  color: greenColor,
                  child: Text('Continuar'),
                ),
              ),
              Container(
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
    }).toList());
  }

  _buildCodeForm() {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
            children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(text: 'Enviamos um código de verificação para'),
              TextSpan(
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
                  text: '\n$_email\n '),
              TextSpan(text: 'É só inserir ele aqui pra continuar.'),
            ]),
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            textColor: Colors.white,
                            onPressed: () async {
                              setState(() {
                                _phase = 'waitingMail';
                              });
                            },
                            color: Colors.grey,
                            child: Text('Voltar'),
                          ),
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Consumer<User>(
                            builder: (context, user, child) {
                              return RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                textColor: Colors.white,
                                onPressed: () async {
                                  setState(() {
                                    _loading = true;
                                  });

                                  if (_alreadyRegistered) {
                                    final result = await user.login(
                                        _email, _verificationCode);
                                    setState(() {
                                      _loading = false;
                                    });

                                    if (!result)
                                      CustomDialog(msg: 'Código inválido')
                                        ..show(context);
                                  } else {
                                    final result = await user.verifyCode(
                                        _email, _verificationCode);
                                    setState(() {
                                      _loading = false;
                                    });

                                    if (!result)
                                      CustomDialog(msg: 'Código inválido')
                                        ..show(context);
                                    else {
                                      setState(() {
                                        _phase = 'waitingName';
                                      });
                                    }
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
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            final result = await user.register(
                                name: _name,
                                email: _email,
                                verificationCode: _verificationCode);
                            setState(() {
                              _loading = false;
                            });

                            if (!result)
                              CustomDialog(msg: 'Falha ao realizar cadastro')
                                ..show(context);
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

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;
    switch (_phase) {
      case 'waitingMail':
        currentWidget = _buildEmailForm();
        break;
      case 'waitingCode':
        currentWidget = _buildCodeForm();
        break;
      case 'waitingName':
        currentWidget = _buildNameForm();
        break;
      default:
        break;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: MyPageView(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                      child: SingleChildScrollView(child:currentWidget),
                    ),
                  ),
                ],
              ),
            ),
            if (_loading) Loader(fullScreen: true),
          ],
        ),
      ),
    );
  }
}
