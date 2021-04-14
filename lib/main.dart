import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cappiapp/main_screen.dart';
import 'package:cappiapp/components/loader.dart';
import 'package:cappiapp/screens/register_screen/register_screen.dart';
import 'package:cappiapp/models/user.dart';
import 'package:cappiapp/models/cappi_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cappi',
      theme: ThemeData(),
      home: SafeArea(child: BaseWidget()),
    );
  }
}

class BaseWidget extends StatefulWidget {
  @override
  BaseWidgetState createState() => BaseWidgetState();
}

class BaseWidgetState extends State<BaseWidget> {
  final User user = User();
  bool _loading = true;

  void _logUserIn() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'auth-token');
    if (token != null) {
      final result = await CappiApi().get(route: '/user', headers: {
        "x-auth": token,
      });

      if (result != null) {
        final body = result['body'];
        user.update(
          isLogged: true,
          name: body['name'],
          email: body['email'],
          balance: body['totalBalance'].toDouble(),
        );
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _logUserIn();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<User>(
      create: (context) => user,
      child: Consumer<User>(
        builder: (context, user, child) {
          if (_loading)
            return Loader(fullScreen: true);
          else if (user.isLogged)
            return MainScreen();
          else
            return RegisterScreen();
        },
      ),
    );
  }
}
