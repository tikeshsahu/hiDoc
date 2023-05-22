import 'package:http/http.dart' as http;

class API {
  static const String _url =
      'http://devapi.hidoc.co:8080/HidocWebApp/api/getArticlesByUid';

  static Future<http.Response> getData() async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        body: {
          'sId': '500',
          'uuId': '',
          'userId': '423914',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        //print(response.statusCode);
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch data');
    }
  }
}
