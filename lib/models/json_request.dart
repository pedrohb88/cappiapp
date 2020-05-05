import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonRequest {

  String url = 'https://cappi-api.herokuapp.com';

  Future<Map<String, dynamic>> get({route, headers}) async{

    var response = await http.get('$url$route', headers:headers);

    if(response.statusCode != 200) return null;

    return {
      "body": JsonDecoder().convert(response.body),
      "headers": response.headers
    };
  }

   Future<Map<String, dynamic>> post({route, body, headers}) async{

     var response = await http.post('$url$route', body: body, headers: headers);

     if(response.statusCode != 200) return null;

     return {
      "body": JsonDecoder().convert(response.body),
      "headers": response.headers
    };
  }
}