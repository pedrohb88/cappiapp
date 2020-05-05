import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappButton extends StatefulWidget {
  
  @override 
  _WhatsappButtonState createState() => _WhatsappButtonState();
}

class _WhatsappButtonState extends State<WhatsappButton>{
  
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

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
      child: Text('Falar com o Cappi Bot'),
      color: Color(0xFF008600),
      textColor: Colors.white,
      onPressed: () async {
        await canLaunch("whatsapp://send?phone=+14155238886")
            ? launch("whatsapp://send?phone=+14155238886")
            : showCustomDialog('Você precisar ter o Whatsapp instalado.');
      },
    );
  }
}
