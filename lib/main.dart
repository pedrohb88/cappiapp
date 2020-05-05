import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'package:cappiapp/screens/register_screen/register_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cappiapp/models/user.dart';
import 'package:cappiapp/models/json_request.dart';

void main() async{
  print('running');
  WidgetsFlutterBinding.ensureInitialized();

  /*var storage = new FlutterSecureStorage();
  await storage.deleteAll();*/

  User user = new User();

  final storage = new FlutterSecureStorage();

  final token = await storage.read(key: 'auth-token');
  if(token != null) {
    print('token armazenado: $token');
    final result = await JsonRequest().get(route: '/user', headers: {
      "x-auth": token,
    });

    if(result != null) {
      print('Usuario vindo do request: ${result['body']['email']}');
      final body = result['body'];
      user = new User(name: body['name'], email: body['email'], balance: body['totalBalance'].toDouble());
    }
  }

  print('usuário logo antes de iniciar o app: $user');

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User user;

  MyApp({@required this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cappi',
      theme: ThemeData(),
      home: BaseWidget(user: user),
    );
  }
}

class BaseWidget extends StatefulWidget {
  final User user;

  BaseWidget({@required this.user}) : assert(user != null);

  @override
  BaseWidgetState createState() => BaseWidgetState();
}

class BaseWidgetState extends State<BaseWidget> {
  
  @override
  Widget build(BuildContext context) {
    print('building');

    print('usuário no widget: ${widget.user}');

    return ChangeNotifierProvider<User>(
      create: (context) => widget.user,
      child: Consumer<User>(
        builder: (context, user, child) {
          print('usuário consumido no main.dart: ${user}');
          if(user != null) print('email do usuário consumido no main.dart: ${user.email}');
          if (user != null && user.email != null)
            return SafeArea(child:MainScreen());
          else
            return RegisterScreen();
        },
      ),
    );
  }
}
